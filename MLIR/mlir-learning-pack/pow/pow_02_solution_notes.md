# POW 02 Solution Notes

In `pow_02_loop_invariant_input.mlir`, this operation is loop-invariant:

```mlir
%scale_plus_bias = arith.addf %scale, %bias : f32
```

It uses only function arguments, not the induction variable `%i` and not loop-carried `%acc`. A safer manual rewrite moves it above the `scf.for`:

```mlir
%scale_plus_bias = arith.addf %scale, %bias : f32
%sum = scf.for %i = %c0 to %n step %c1 iter_args(%acc = %zero) -> (f32) {
  %x = memref.load %A[%i] : memref<?xf32>
  %prod = arith.mulf %x, %scale_plus_bias : f32
  %next = arith.addf %acc, %prod : f32
  scf.yield %next : f32
}
```

Why it matters: the original computes `%scale + %bias` `n` times. The rewrite computes it once.
