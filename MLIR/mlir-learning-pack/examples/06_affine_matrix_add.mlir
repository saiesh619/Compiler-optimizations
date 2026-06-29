// 06_affine_matrix_add.mlir
// Goal: use affine.for for a simple static matrix add.
// Try: mlir-opt --lower-affine examples/06_affine_matrix_add.mlir

module {
  func.func @matrix_add_16x16(
      %A: memref<16x16xf32>,
      %B: memref<16x16xf32>,
      %C: memref<16x16xf32>) {
    affine.for %i = 0 to 16 {
      affine.for %j = 0 to 16 {
        %a = affine.load %A[%i, %j] : memref<16x16xf32>
        %b = affine.load %B[%i, %j] : memref<16x16xf32>
        %sum = arith.addf %a, %b : f32
        affine.store %sum, %C[%i, %j] : memref<16x16xf32>
      }
    }
    func.return
  }
}
