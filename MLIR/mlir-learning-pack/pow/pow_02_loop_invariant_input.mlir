// pow_02_loop_invariant_input.mlir
// Proof-of-work task: identify work inside the loop that does not depend on %i.
// Then rewrite it by moving invariant computation before the loop.

module {
  func.func @loop_invariant_demo(%A: memref<?xf32>, %n: index, %scale: f32, %bias: f32) -> f32 {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %zero = arith.constant 0.0 : f32

    %sum = scf.for %i = %c0 to %n step %c1 iter_args(%acc = %zero) -> (f32) {
      // This does not depend on %i. It is loop invariant.
      %scale_plus_bias = arith.addf %scale, %bias : f32

      %x = memref.load %A[%i] : memref<?xf32>
      %prod = arith.mulf %x, %scale_plus_bias : f32
      %next = arith.addf %acc, %prod : f32
      scf.yield %next : f32
    }

    func.return %sum : f32
  }
}
