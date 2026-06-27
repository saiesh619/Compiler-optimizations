#include "llvm/IR/PassManager.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Function.h"

using namespace llvm;

struct DeadCodeElimination : public PassInfoMixin<DeadCodeElimination> {

    PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {

        bool removed = false;

        for (auto &BB : F) {
            for (auto it = BB.begin(); it != BB.end();) {

                Instruction &I = *it++;

                if (I.isTerminator())
                    continue;

                if (I.mayHaveSideEffects())
                    continue;

                if (I.use_empty()) {

                    errs() << "Removing: " << I << "\n";

                    I.eraseFromParent();
                    removed = true;
                }
            }
        }

        return removed ? PreservedAnalyses::none()
                       : PreservedAnalyses::all();
    }
};