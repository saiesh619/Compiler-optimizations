# IRGuard

IRGuard is an LLVM pass plugin that scans LLVM IR for security and correctness issues.

It is designed as a compact compiler-engineering project that demonstrates:

- LLVM pass writing
- Static analysis over LLVM IR
- Basic security bug detection
- IR-level reasoning
- Compiler tooling with CMake

## What IRGuard Detects

IRGuard currently reports:

1. Integer division or remainder by constant zero
2. Invalid shift amounts
3. Large integer truncations
4. Risky C library calls such as `strcpy`, `sprintf`, and `scanf`
5. Dynamic or loop-based stack allocations
6. Simple null-pointer load/store patterns

This is not a full production static analyzer. It is intentionally small enough to understand, extend, and explain in interviews.

## Requirements

You need:

- LLVM
- Clang
- CMake
- A C++17 compiler

Check that LLVM is installed:

```bash
llvm-config --version
clang --version
opt --version
```

## Build

```bash
cmake -S . -B build -DLLVM_DIR="$(llvm-config --cmakedir)"
cmake --build build
```

Find the generated plugin:

```bash
find build -name '*IRGuardPass*'
```

## Run on the Example

Compile the sample C file to LLVM IR:

```bash
clang -O0 -g -emit-llvm -S examples/vulnerable.c -o vulnerable.ll
```

Run the LLVM pass:

```bash
PLUGIN=$(find build -name '*IRGuardPass*' -type f | head -n 1)

opt -load-pass-plugin "$PLUGIN" \
    -passes='function(ir-guard)' \
    -disable-output \
    vulnerable.ll
```

Expected output will look similar to:

```text
[IRGuard][critical] divide_by_zero @ examples/vulnerable.c:6
  integer division or remainder by constant zero

[IRGuard][warning] unsafe_copy @ examples/vulnerable.c:18
  call to risky C library function `strcpy`; prefer bounded alternatives or explicit validation

[IRGuard][critical] null_dereference @ examples/vulnerable.c:28
  load through a pointer known to be null
```

## Why This Project Is Useful

This project is useful for a systems, compiler, or security-focused GitHub profile because it shows work below the source-code level.

Most beginner static-analysis projects operate directly on source text. IRGuard operates on LLVM IR, which means it analyzes code after Clang lowers C/C++ into compiler intermediate representation.

## Project Extension Ideas

Good next improvements:

1. Add JSON output for GitHub Actions integration.
2. Add taint tracking from function parameters.
3. Add detection for unchecked `malloc` returns.
4. Add detection for memory leaks.
5. Add SARIF output so GitHub can show code-scanning alerts.
6. Add unit tests using LLVM `lit`.
7. Add support for C++ functions such as `operator new`.
8. Add a severity configuration file.

## Example Workflow

```bash
clang -O0 -g -emit-llvm -S examples/vulnerable.c -o vulnerable.ll

PLUGIN=$(find build -name '*IRGuardPass*' -type f | head -n 1)

opt -load-pass-plugin "$PLUGIN" \
    -passes='function(ir-guard)' \
    -disable-output \
    vulnerable.ll
```

## Repository Description

```text
IRGuard: an LLVM pass plugin that detects risky C/C++ patterns directly from LLVM IR.
```

## License

MIT License.
