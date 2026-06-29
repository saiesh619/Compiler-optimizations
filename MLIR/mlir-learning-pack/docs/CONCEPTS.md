# MLIR Concepts in Plain Terms

## Operation

Everything executable is an operation. A function is an operation. An add is an operation. A loop is an operation. A module is also an operation.

Generic form:

```mlir
%result = "dialect.operation"(%operand) {attribute = 123 : i64}
  : (i32) -> i32
```

Custom/pretty form:

```mlir
%result = arith.addi %lhs, %rhs : i32
```

The two forms represent the same underlying idea: operation name, operands, attributes, result types, and sometimes regions.

## SSA values

Values start with `%`. Most operation results are SSA values: assigned once, used many times.

```mlir
%c1 = arith.constant 1 : i32
%c2 = arith.constant 2 : i32
%sum = arith.addi %c1, %c2 : i32
```

## Blocks and block arguments

MLIR does not need classic LLVM-style phi nodes. A destination block can receive arguments from branches.

```mlir
cf.br ^merge(%x : i32)
^merge(%v : i32):
  func.return %v : i32
```

## Regions

A region is nested code owned by an operation. Functions, loops, `scf.if`, `scf.for`, and `linalg.generic` all contain regions.

## Dialects

A dialect is a namespace plus a set of operations/types/attributes. Examples:

- `builtin`: module and core containers.
- `func`: functions and calls.
- `arith`: integer and floating arithmetic.
- `cf`: unstructured control flow.
- `scf`: structured control flow.
- `memref`: memory buffers.
- `affine`: affine loop/math constructs.
- `tensor`: immutable tensor-value operations.
- `linalg`: structured linear algebra.
- `vector`: target-independent vector operations.
- `math`: math library operations.

## High-level to low-level flow

A common mental model:

```text
tensor/linalg/affine/scf
        ↓
memref/vector/scf
        ↓
cf/func/arith
        ↓
llvm dialect
        ↓
LLVM IR / object code
```

Not every project uses the same lowering stack. MLIR is a framework, not one mandatory pipeline.
