// 09_linalg_generic_add.mlir
// Goal: express elementwise tensor add as a structured linalg operation.

#map = affine_map<(d0) -> (d0)>

module {
  func.func @tensor_add_4(%A: tensor<4xf32>, %B: tensor<4xf32>) -> tensor<4xf32> {
    %empty = tensor.empty() : tensor<4xf32>

    %C = linalg.generic {
        indexing_maps = [#map, #map, #map],
        iterator_types = ["parallel"]
      }
      ins(%A, %B : tensor<4xf32>, tensor<4xf32>)
      outs(%empty : tensor<4xf32>) {
    ^bb0(%a: f32, %b: f32, %old: f32):
      %sum = arith.addf %a, %b : f32
      linalg.yield %sum : f32
    } -> tensor<4xf32>

    func.return %C : tensor<4xf32>
  }
}
