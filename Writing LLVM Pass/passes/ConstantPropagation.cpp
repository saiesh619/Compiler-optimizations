#include "llvm/IR/PassManager.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"

using namespace llvm;

struct ConstantPropagation : public PassInfoMixin<ConstantPropagation> {

    PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {

        for (auto &BB : F) {
            for (auto &I : BB) {

                if (auto *binOp = dyn_cast<BinaryOperator>(&I)) {

                    auto *C1 = dyn_cast<ConstantInt>(binOp->getOperand(0));
                    auto *C2 = dyn_cast<ConstantInt>(binOp->getOperand(1));

                    if (C1 && C2) {

                        Constant *result =
                            ConstantExpr::get(binOp->getOpcode(), C1, C2);

                        binOp->replaceAllUsesWith(result);
                    }
                }
            }
        }

        return PreservedAnalyses::none();
    }
};