#include "llvm/IR/PassManager.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Constants.h"

using namespace llvm;

struct LICM : public PassInfoMixin<LICM> {

    PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {

        for (auto &BB : F) {
            for (auto &I : BB) {

                if (auto *binOp = dyn_cast<BinaryOperator>(&I)) {

                    if (isa<Constant>(binOp->getOperand(0)) &&
                        isa<Constant>(binOp->getOperand(1))) {

                        Constant *result =
                            ConstantExpr::get(
                                binOp->getOpcode(),
                                cast<Constant>(binOp->getOperand(0)),
                                cast<Constant>(binOp->getOperand(1)));

                        binOp->replaceAllUsesWith(result);
                    }
                }
            }
        }

        return PreservedAnalyses::none();
    }
};