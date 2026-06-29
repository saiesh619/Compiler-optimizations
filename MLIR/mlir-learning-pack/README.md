# MLIR Learning Pack

A repo-ready set of MLIR examples that starts from basic syntax and builds up to structured control flow, memrefs, affine loops, tensor/linalg programs, vector code, and optimization exercises.

This is meant for learning and GitHub proof-of-work. The files are intentionally small and heavily commented. Most examples are standalone `.mlir` files you can run through `mlir-opt` once you have an LLVM/MLIR build installed.

## Suggested setup

Build MLIR from LLVM, then add your build `bin` directory to `PATH`:

```bash
git clone https://github.com/llvm/llvm-project.git
mkdir -p llvm-project/build
cd llvm-project/build
cmake -G Ninja ../llvm \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_BUILD_EXAMPLES=ON \
  -DLLVM_TARGETS_TO_BUILD="Native" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=ON
cmake --build . --target check-mlir
export PATH="$PWD/bin:$PATH"
```

## Validate examples

```bash
bash scripts/check-syntax.sh
```

That script runs `mlir-opt --verify-diagnostics` over the example files. If your MLIR is newer/older and a dialect syntax has changed, start with `examples/00` through `examples/07`; those use very stable core dialects.

## Learning order

1. `examples/00_minimal_module.mlir` — module, function, constants, return.
2. `examples/01_arith_and_func.mlir` — integer/floating arithmetic and calls.
3. `examples/02_generic_form_and_attrs.mlir` — generic operation form, attributes, locations.
4. `examples/03_cf_blocks_and_block_args.mlir` — CFG-style blocks and block arguments.
5. `examples/04_scf_if_for.mlir` — structured `if`, `for`, loop-carried values.
6. `examples/05_memref_alloc_load_store.mlir` — buffers, load/store, allocation.
7. `examples/06_affine_matrix_add.mlir` — affine loops and matrix add.
8. `examples/07_scf_reduce_memref.mlir` — sum reduction with `scf.for`.
9. `examples/08_tensor_extract_insert.mlir` — tensor value semantics.
10. `examples/09_linalg_generic_add.mlir` — linalg generic elementwise add.
11. `examples/10_linalg_matmul.mlir` — linalg named matmul.
12. `examples/11_vector_basics.mlir` — vector arithmetic and transfer read/write.
13. `examples/12_math_pow.mlir` — `math.powf`, `math.fpowi`, scalar/vector power.
14. `examples/13_saxpy_scf_memref.mlir` — end-to-end numeric kernel.
15. `examples/14_tiled_matmul_scf.mlir` — tiled loop structure for matmul.
16. `examples/15_mixed_tensor_linalg_pipeline.mlir` — high-level tensor/linalg pipeline.
17. `examples/16_lowering_notes.mlir` — lowering-oriented example with pipeline comments.

## Proof-of-work exercises

The `pow/` folder contains small tasks that show actual compiler thinking:

- `pow_01_canonicalize_cse_input.mlir`: remove redundant arithmetic through canonicalization/CSE.
- `pow_01_expected_after.mlir`: what the simplified IR should look like conceptually.
- `pow_02_loop_invariant_input.mlir`: identify loop-invariant work and move it.
- `pow_02_solution_notes.md`: explanation and safer rewrite.
- `pow_03_tile_and_vectorize_challenge.mlir`: TODO challenge for tiling and vector thinking.

## Useful commands

```bash
# Parse/print one file.
mlir-opt examples/00_minimal_module.mlir

# Canonicalize and eliminate common subexpressions.
mlir-opt --canonicalize --cse pow/pow_01_canonicalize_cse_input.mlir

# Lower affine loops to scf-style loops.
mlir-opt --lower-affine examples/06_affine_matrix_add.mlir

# Lower structured control flow toward CFG form.
mlir-opt --convert-scf-to-cf examples/04_scf_if_for.mlir
```

Treat these examples as source material. Copy them into your repo, commit each stage, and add notes on what changed after each pass. That is much better proof-of-work than dumping one final file.
