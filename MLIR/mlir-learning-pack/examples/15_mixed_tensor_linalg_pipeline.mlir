// 15_mixed_tensor_linalg_pipeline.mlir
// Goal: combine linalg.matmul with linalg.generic post-processing.
// Operation: D = relu((A * B) + Bias)

#map2 = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @matmul_bias_relu(
      %A: tensor<4x8xf32>,
      %B: tensor<8x4xf32>,
      %Bias: tensor<4x4xf32>) -> tensor<4x4xf32> {
    %empty = tensor.empty() : tensor<4x4xf32>
    %zero = arith.constant 0.0 : f32

    %init = linalg.fill ins(%zero : f32)
      outs(%empty : tensor<4x4xf32>) -> tensor<4x4xf32>

    %MM = linalg.matmul
      ins(%A, %B : tensor<4x8xf32>, tensor<8x4xf32>)
      outs(%init : tensor<4x4xf32>) -> tensor<4x4xf32>

    %out_empty = tensor.empty() : tensor<4x4xf32>

    %D = linalg.generic {
        indexing_maps = [#map2, #map2, #map2],
        iterator_types = ["parallel", "parallel"]
      }
      ins(%MM, %Bias : tensor<4x4xf32>, tensor<4x4xf32>)
      outs(%out_empty : tensor<4x4xf32>) {
    ^bb0(%mm: f32, %bias: f32, %old: f32):
      %sum = arith.addf %mm, %bias : f32
      %positive = arith.cmpf ogt, %sum, %zero : f32
      %relu = arith.select %positive, %sum, %zero : f32
      linalg.yield %relu : f32
    } -> tensor<4x4xf32>

    func.return %D : tensor<4x4xf32>
  }
}
