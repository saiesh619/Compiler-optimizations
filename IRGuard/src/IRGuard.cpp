#include "llvm/ADT/APInt.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

#include <string>

using namespace llvm;

namespace {

static std::string locationOf(const Instruction &I) {
    if (DebugLoc DL = I.getDebugLoc()) {
        const DILocation *Loc = DL.get();
        std::string File = Loc->getFilename().str();

        if (File.empty()) {
            File = "<unknown-file>";
        }

        return File + ":" + std::to_string(Loc->getLine());
    }

    return "<no debug info>";
}

static bool isZeroConstant(const Value *V) {
    const auto *CI = dyn_cast<ConstantInt>(V);
    return CI && CI->isZero();
}

static bool isNullPointerConstant(const Value *V) {
    return isa<ConstantPointerNull>(V->stripPointerCasts());
}

static bool isKnownNullPointer(
    const Value *V,
    const SmallPtrSetImpl<const Value *> &KnownNullValues
) {
    V = V->stripPointerCasts();

    if (isNullPointerConstant(V)) {
        return true;
    }

    return KnownNullValues.contains(V);
}

static bool isUnsafeCLibraryCall(StringRef Name) {
    return Name == "gets" ||
           Name == "strcpy" ||
           Name == "strcat" ||
           Name == "sprintf" ||
           Name == "vsprintf" ||
           Name == "scanf" ||
           Name == "sscanf" ||
           Name == "fscanf";
}

static void reportIssue(
    StringRef Severity,
    const Function &F,
    const Instruction &I,
    StringRef Message
) {
    errs() << "[IRGuard][" << Severity << "] "
           << F.getName() << " @ " << locationOf(I) << "\n";

    errs() << "  " << Message << "\n";
    errs() << "  IR: ";
    I.print(errs());
    errs() << "\n\n";
}

class IRGuardPass : public PassInfoMixin<IRGuardPass> {
public:
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
        if (F.isDeclaration()) {
            return PreservedAnalyses::all();
        }

        LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);

        SmallPtrSet<const Value *, 32> KnownNullValues;
        SmallPtrSet<const Value *, 32> NullPointerSlots;

        for (BasicBlock &BB : F) {
            for (Instruction &I : BB) {
                detectDivisionByZero(F, I);
                detectInvalidShift(F, I);
                detectDangerousTruncation(F, I);
                detectUnsafeCalls(F, I);
                detectStackAllocationInLoop(F, I, LI);
                trackNullPointers(F, I, KnownNullValues, NullPointerSlots);
            }
        }

        return PreservedAnalyses::all();
    }

private:
    static void detectDivisionByZero(const Function &F, const Instruction &I) {
        const auto *BO = dyn_cast<BinaryOperator>(&I);
        if (!BO) {
            return;
        }

        unsigned Op = BO->getOpcode();

        bool IsDivOrRem =
            Op == Instruction::SDiv ||
            Op == Instruction::UDiv ||
            Op == Instruction::SRem ||
            Op == Instruction::URem;

        if (!IsDivOrRem) {
            return;
        }

        if (isZeroConstant(BO->getOperand(1))) {
            reportIssue(
                "critical",
                F,
                I,
                "integer division or remainder by constant zero"
            );
        }
    }

    static void detectInvalidShift(const Function &F, const Instruction &I) {
        const auto *BO = dyn_cast<BinaryOperator>(&I);
        if (!BO) {
            return;
        }

        unsigned Op = BO->getOpcode();

        bool IsShift =
            Op == Instruction::Shl ||
            Op == Instruction::LShr ||
            Op == Instruction::AShr;

        if (!IsShift) {
            return;
        }

        const auto *LhsType = dyn_cast<IntegerType>(BO->getOperand(0)->getType());
        const auto *ShiftAmount = dyn_cast<ConstantInt>(BO->getOperand(1));

        if (!LhsType || !ShiftAmount) {
            return;
        }

        unsigned BitWidth = LhsType->getBitWidth();
        APInt WidthAsAPInt(ShiftAmount->getBitWidth(), BitWidth);

        if (ShiftAmount->getValue().uge(WidthAsAPInt)) {
            reportIssue(
                "critical",
                F,
                I,
                "shift amount is greater than or equal to the integer bit width"
            );
        }
    }

    static void detectDangerousTruncation(const Function &F, const Instruction &I) {
        const auto *TI = dyn_cast<TruncInst>(&I);
        if (!TI) {
            return;
        }

        const auto *SrcType = dyn_cast<IntegerType>(TI->getSrcTy());
        const auto *DstType = dyn_cast<IntegerType>(TI->getDestTy());

        if (!SrcType || !DstType) {
            return;
        }

        unsigned SrcWidth = SrcType->getBitWidth();
        unsigned DstWidth = DstType->getBitWidth();

        if (SrcWidth >= DstWidth + 16) {
            reportIssue(
                "warning",
                F,
                I,
                "large integer truncation may lose significant data"
            );
        }
    }

    static void detectUnsafeCalls(const Function &F, const Instruction &I) {
        const auto *CB = dyn_cast<CallBase>(&I);
        if (!CB) {
            return;
        }

        const Function *Callee = CB->getCalledFunction();
        if (!Callee) {
            return;
        }

        StringRef Name = Callee->getName();

        if (isUnsafeCLibraryCall(Name)) {
            std::string Message =
                "call to risky C library function `" + Name.str() +
                "`; prefer bounded alternatives or explicit validation";

            reportIssue("warning", F, I, Message);
        }
    }

    static void detectStackAllocationInLoop(
        const Function &F,
        const Instruction &I,
        LoopInfo &LI
    ) {
        const auto *AI = dyn_cast<AllocaInst>(&I);
        if (!AI) {
            return;
        }

        bool IsInsideLoop = LI.getLoopFor(I.getParent()) != nullptr;
        bool IsDynamicAlloca = !AI->isStaticAlloca();

        if (IsInsideLoop || IsDynamicAlloca) {
            reportIssue(
                "warning",
                F,
                I,
                "stack allocation appears inside a loop or uses dynamic size"
            );
        }
    }

    static void trackNullPointers(
        const Function &F,
        Instruction &I,
        SmallPtrSetImpl<const Value *> &KnownNullValues,
        SmallPtrSetImpl<const Value *> &NullPointerSlots
    ) {
        if (auto *SI = dyn_cast<StoreInst>(&I)) {
            const Value *StoredValue = SI->getValueOperand()->stripPointerCasts();
            const Value *PointerOperand = SI->getPointerOperand()->stripPointerCasts();

            if (isKnownNullPointer(PointerOperand, KnownNullValues)) {
                reportIssue(
                    "critical",
                    F,
                    I,
                    "store through a pointer known to be null"
                );
            }

            if (isa<AllocaInst>(PointerOperand)) {
                if (isNullPointerConstant(StoredValue)) {
                    NullPointerSlots.insert(PointerOperand);
                } else {
                    NullPointerSlots.erase(PointerOperand);
                }
            }

            return;
        }

        if (auto *Load = dyn_cast<LoadInst>(&I)) {
            const Value *PointerOperand = Load->getPointerOperand()->stripPointerCasts();

            if (isKnownNullPointer(PointerOperand, KnownNullValues)) {
                reportIssue(
                    "critical",
                    F,
                    I,
                    "load through a pointer known to be null"
                );
            }

            if (Load->getType()->isPointerTy() && NullPointerSlots.contains(PointerOperand)) {
                KnownNullValues.insert(Load);
            }

            return;
        }
    }
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION,
        "IRGuardPass",
        LLVM_VERSION_STRING,
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name,
                   FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "ir-guard") {
                        FPM.addPass(IRGuardPass());
                        return true;
                    }

                    return false;
                }
            );
        }
    };
}
