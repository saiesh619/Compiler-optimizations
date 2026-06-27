# LLVM Optimization Framework

A compiler optimization framework built using **LLVM and C++** that implements classic compiler optimization passes and applies them to LLVM Intermediate Representation (IR).

This project demonstrates how custom optimization passes can be designed, integrated, and executed using the LLVM infrastructure.

---

# Features

The framework implements the following compiler optimization passes:

## 1. Dead Code Elimination (DCE)

Removes instructions that do not affect the final program output.

Example:

```
a = b + c
// result never used
```

After optimization the instruction is removed.

---

## 2. Constant Propagation

Replaces variables with known constant values to simplify computations.

Example:

```
a = 5
b = a + 10
```

After optimization:

```
b = 15
```

---

## 3. Common Subexpression Elimination (CSE)

Detects and removes redundant computations.

Example:

```
x = a + b
y = a + b
```

After optimization:

```
x = a + b
y = x
```

---

## 4. Loop Invariant Code Motion (LICM)

Moves computations that produce the same result in every loop iteration outside the loop.

Example:

```
for(i=0;i<n;i++)
{
    x = a + b
}
```

Optimized:

```
x = a + b
for(i=0;i<n;i++)
{
}
```

---

# Project Structure

```
llvm-optimization-framework
│
├── passes
│   ├── DeadCodeElimination.cpp
│   ├── ConstantPropagation.cpp
│   ├── CSE.cpp
│   └── LoopInvariantCodeMotion.cpp
│
├── test_programs
│   ├── test1.c
│   └── test2.c
│
├── build
│
├── CMakeLists.txt
└── README.md
```

---

# Requirements

- LLVM (installed via Homebrew)
- Clang
- CMake
- macOS

Install LLVM:

```
brew install llvm
```

Add LLVM to PATH:

```
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
```

---

# Build Instructions

Navigate to the project directory:

```
cd llvm-optimization-framework
```

Create build directory:

```
mkdir build
cd build
```

Configure project:

```
CC=/opt/homebrew/opt/llvm/bin/clang \
CXX=/opt/homebrew/opt/llvm/bin/clang++ \
cmake ..
```

Build the project:

```
make
```

This generates the shared library:

```
libOptimizationPasses.so
```

---

# Generate LLVM IR

Compile a test program to LLVM IR:

```
clang -O0 -S -emit-llvm test_programs/test1.c -o test1.ll
```

---

# Run Optimization Passes

Apply all optimization passes:

```
opt -load-pass-plugin ./build/libOptimizationPasses.so \
-passes="dead-code-elimination,constant-propagation,cse,licm" \
test1.ll -S -o optimized.ll
```

---

# Example

Before Optimization:

```
x = a + b
y = a + b
```

After Optimization:

```
x = a + b
y = x
```

---

# Learning Outcomes

This project demonstrates:

- LLVM compiler infrastructure
- Writing custom LLVM optimization passes
- Working with LLVM Intermediate Representation (IR)
- Classic compiler optimization techniques
- Build systems using CMake
- Program analysis and transformation

---

# Author

**Harshad Magdum**  
Computer Science Student
