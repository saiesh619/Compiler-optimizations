// 08_tensor_extract_insert.mlir
// Goal: tensor operations produce new tensor values instead of mutating memory.

module {
  func.func @set_first_element(%input: tensor<4xf32>, %x: f32) -> tensor<4xf32> {
    %c0 = arith.constant 0 : index
    %out = tensor.insert %x into %input[%c0] : tensor<4xf32>
    func.return %out : tensor<4xf32>
  }

  func.func @sum_first_two(%input: tensor<4xf32>) -> f32 {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %a = tensor.extract %input[%c0] : tensor<4xf32>
    %b = tensor.extract %input[%c1] : tensor<4xf32>
    %sum = arith.addf %a, %b : f32
    func.return %sum : f32
  }
}
