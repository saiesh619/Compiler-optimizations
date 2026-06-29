// 07_scf_reduce_memref.mlir
// Goal: reduction over a dynamic-size memref using scf.for.

module {
  func.func @sum_memref(%A: memref<?xf32>, %n: index) -> f32 {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %zero = arith.constant 0.0 : f32

    %sum = scf.for %i = %c0 to %n step %c1 iter_args(%acc = %zero) -> (f32) {
      %x = memref.load %A[%i] : memref<?xf32>
      %next = arith.addf %acc, %x : f32
      scf.yield %next : f32
    }

    func.return %sum : f32
  }
}
