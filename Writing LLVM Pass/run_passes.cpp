#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include "passes/DeadCodeElimination.cpp"
#include "passes/ConstantPropagation.cpp"
#include "passes/CSE.cpp"
#include "passes/LoopInvariantCodeMotion.cpp"

using namespace llvm;

int main(int argc, char **argv) {

    if (argc < 2) {
        errs() << "Usage: ./run_passes <input.ll>\n";
        return 1;
    }

    LLVMContext Context;
    SMDiagnostic Err;

    auto M = parseIRFile(argv[1], Err, Context);

    if (!M) {
        Err.print(argv[0], errs());
        return 1;
    }

    PassBuilder PB;

    FunctionAnalysisManager FAM;
    PB.registerFunctionAnalyses(FAM);

    FunctionPassManager FPM;

    FPM.addPass(DeadCodeElimination());
    FPM.addPass(ConstantPropagation());
    FPM.addPass(CSE());
    FPM.addPass(LICM());

    for (Function &F : *M) {
        if (!F.isDeclaration())
            FPM.run(F, FAM);
    }

    M->print(outs(), nullptr);
}