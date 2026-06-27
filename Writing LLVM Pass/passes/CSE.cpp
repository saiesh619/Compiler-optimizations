#include "llvm/IR/PassManager.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Function.h"
#include <map>

using namespace llvm;

struct CSE : public PassInfoMixin<CSE> {

    PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {

        std::map<std::string, Value*> exprMap;

        for (auto &BB : F) {
            for (auto &I : BB) {

                if (auto *binOp = dyn_cast<BinaryOperator>(&I)) {

                    std::string key =
                        std::to_string(binOp->getOpcode()) +
                        std::to_string((uintptr_t)binOp->getOperand(0)) +
                        std::to_string((uintptr_t)binOp->getOperand(1));

                    if (exprMap.count(key)) {
                        binOp->replaceAllUsesWith(exprMap[key]);
                    } else {
                        exprMap[key] = &I;
                    }
                }
            }
        }

        return PreservedAnalyses::none();
    }
};