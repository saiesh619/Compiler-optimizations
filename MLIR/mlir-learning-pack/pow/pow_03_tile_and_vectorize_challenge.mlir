// pow_03_tile_and_vectorize_challenge.mlir
// Challenge: turn this simple elementwise add into a tiled/vectorized version.
// Start with tile size 4, then use vector<4xf32> transfer_read/write.

module {
  func.func @elementwise_add(%A: memref<?xf32>, %B: memref<?xf32>, %C: memref<?xf32>, %n: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index

    scf.for %i = %c0 to %n step %c1 {
      %a = memref.load %A[%i] : memref<?xf32>
      %b = memref.load %B[%i] : memref<?xf32>
      %sum = arith.addf %a, %b : f32
      memref.store %sum, %C[%i] : memref<?xf32>
    }

    func.return
  }
}
