// 10_linalg_matmul.mlir
// Goal: named linalg op for matrix multiplication.

module {
  func.func @matmul_4x8x4(
      %A: tensor<4x8xf32>,
      %B: tensor<8x4xf32>) -> tensor<4x4xf32> {
    %empty = tensor.empty() : tensor<4x4xf32>
    %zero = arith.constant 0.0 : f32
    %init = linalg.fill ins(%zero : f32) outs(%empty : tensor<4x4xf32>) -> tensor<4x4xf32>

    %C = linalg.matmul
      ins(%A, %B : tensor<4x8xf32>, tensor<8x4xf32>)
      outs(%init : tensor<4x4xf32>) -> tensor<4x4xf32>

    func.return %C : tensor<4x4xf32>
  }
}
