
# Compiler Optimizations

A collection of compiler engineering projects focused on LLVM, MLIR, intermediate representations, optimization passes, and language implementation.

This repository is organized as a practical learning and experimentation space for building compiler infrastructure from the ground up. It includes projects ranging from basic compiler construction to LLVM pass development, MLIR examples, IR-level analysis, and optimization experiments.

## Repository Structure

```text
Compiler-Optimizations/
├── Craftting_Compilers/      # Notes and projects from compiler construction
├── IRGuard/                  # LLVM/IR analysis and safety-oriented tooling
├── Kaliescope/               # Kaleidoscope language implementation experiments
├── MLIR/                     # MLIR examples, dialect exploration, and lowering experiments
├── Writing LLVM Pass/        # LLVM pass development examples
├── .gitattributes
└── README.md
````

## Projects

### Crafting Compilers

This section contains compiler construction experiments and notes. The goal is to build a strong foundation in how programming languages are parsed, represented, analyzed, and transformed.

Topics covered may include:

* Lexical analysis
* Parsing
* Abstract syntax trees
* Semantic analysis
* Intermediate representations
* Code generation
* Optimization fundamentals

### IRGuard

`IRGuard` focuses on analyzing LLVM IR for correctness, safety, and optimization opportunities.

Possible areas of exploration:

* LLVM IR inspection
* Undefined behavior detection
* Dead code and unreachable code analysis
* Control-flow graph analysis
* Instruction-level validation
* Optimization safety checks

The goal of this project is to understand how compiler tools reason about low-level program representations.

### Kaleidoscope

This project is based on the classic LLVM Kaleidoscope language tutorial. It is used to understand the end-to-end process of implementing a small programming language.

Core concepts include:

* Lexer implementation
* Parser implementation
* AST construction
* LLVM IR generation
* JIT compilation
* Function definitions
* Expressions and control flow
* Basic optimization passes

### MLIR

The `MLIR` directory contains examples and experiments using Multi-Level Intermediate Representation.

This section is intended to build understanding from basic MLIR syntax to more complex compiler transformations.

Topics may include:

* MLIR modules, functions, blocks, and operations
* SSA values
* Dialects
* `arith`, `func`, `scf`, `memref`, `affine`, `linalg`, `tensor`, and `vector`
* Loop transformations
* Tensor and buffer abstractions
* Lowering pipelines
* Optimization exercises

### Writing LLVM Pass

This project contains examples of writing LLVM passes.

The purpose is to understand how LLVM transformations are implemented and integrated into the compiler pipeline.

Topics include:

* LLVM pass structure
* Function passes
* Module passes
* Analysis passes
* Transformation passes
* Pass registration
* Running passes with `opt`
* Inspecting transformed LLVM IR

## Goals

The main goals of this repository are:

* Build practical knowledge of compiler internals.
* Understand LLVM IR and MLIR from first principles.
* Implement optimization passes.
* Experiment with language frontends and intermediate representations.
* Learn how real compiler pipelines are structured.
* Create a strong portfolio of compiler engineering projects.

## Prerequisites

Recommended background:

* C++ programming
* Basic data structures and algorithms
* Familiarity with operating systems concepts
* Basic knowledge of assembly or low-level programming
* Interest in compilers, programming languages, and optimization

Recommended tools:

* LLVM
* MLIR
* CMake
* Ninja
* Clang
* Git
* Python

## Building LLVM and MLIR

A common setup for LLVM and MLIR development is:

```bash
git clone https://github.com/llvm/llvm-project.git
cd llvm-project

cmake -S llvm -B build \
  -G Ninja \
  -DLLVM_ENABLE_PROJECTS="clang;mlir" \
  -DLLVM_BUILD_EXAMPLES=ON \
  -DLLVM_TARGETS_TO_BUILD="host" \
  -DCMAKE_BUILD_TYPE=Release

cmake --build build
```

After building, add the tools to your path:

```bash
export PATH="$PWD/build/bin:$PATH"
```

Useful tools include:

```bash
clang
opt
llc
llvm-dis
llvm-as
mlir-opt
mlir-translate
```

## Example Commands

Run an LLVM pass:

```bash
opt -passes="<pass-name>" input.ll -S -o output.ll
```

Inspect LLVM IR from C/C++ code:

```bash
clang -S -emit-llvm example.c -o example.ll
```

Run MLIR syntax and transformation checks:

```bash
mlir-opt example.mlir
```

Lower MLIR through a pipeline:

```bash
mlir-opt input.mlir \
  --convert-scf-to-cf \
  --convert-cf-to-llvm \
  --convert-func-to-llvm \
  --reconcile-unrealized-casts
```

## Suggested Learning Path

A good order for working through this repository is:

1. Start with `Craftting_Compilers` to understand compiler fundamentals.
2. Move to `Kaliescope` to implement a small language using LLVM.
3. Study `Writing LLVM Pass` to learn how compiler optimizations are implemented.
4. Explore `IRGuard` to analyze and reason about LLVM IR.
5. Work through `MLIR` to understand modern multi-level compiler infrastructure.

## Project Status

This repository is actively evolving. The current focus is on building small, understandable compiler projects that demonstrate important compiler concepts clearly.

Planned improvements:

* More LLVM optimization passes
* More MLIR lowering examples
* Documentation for each project directory
* Test cases for compiler transformations
* More examples involving control-flow and data-flow analysis
* End-to-end frontend-to-LLVM pipeline examples

## Notes

Some directory names currently reflect the original development structure. They may be cleaned up later for consistency.

Recommended cleanup:

```bash
rm -f .DS_Store
echo ".DS_Store" >> .gitignore
```

Optional rename suggestions:

```text
Craftting_Compilers  -> Crafting_Compilers
Kaliescope           -> Kaleidoscope
Writing LLVM Pass    -> Writing_LLVM_Pass
```

## License

This repository is intended for educational and portfolio purposes. Add a license file before distributing or accepting external contributions.

Recommended options:

* MIT License for permissive open-source use
* Apache 2.0 for a more formal permissive license
* No license if the repository is only for personal reference

## Author

Created and maintained by [saiesh619](https://github.com/saiesh619).

## Summary

`Compiler-Optimizations` is a hands-on compiler engineering repository focused on LLVM, MLIR, IR analysis, and optimization. It is designed to grow from basic compiler construction concepts into more advanced compiler infrastructure projects.

```

One thing to fix before making the repo look polished: remove `.DS_Store` and add it to `.gitignore`. Also consider renaming `Craftting_Compilers` and `Kaliescope`; small spelling issues make the repo look less professional even if the content is solid.
```
