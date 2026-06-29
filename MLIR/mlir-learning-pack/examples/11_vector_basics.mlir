// 11_vector_basics.mlir
// Goal: vector values and vector transfer operations.

module {
  func.func @vector_add(%a: vector<4xf32>, %b: vector<4xf32>) -> vector<4xf32> {
    %sum = arith.addf %a, %b : vector<4xf32>
    func.return %sum : vector<4xf32>
  }

  func.func @load_add_store_vector(%A: memref<4xf32>, %B: memref<4xf32>, %C: memref<4xf32>) {
    %c0 = arith.constant 0 : index
    %pad = arith.constant 0.0 : f32

    %va = vector.transfer_read %A[%c0], %pad : memref<4xf32>, vector<4xf32>
    %vb = vector.transfer_read %B[%c0], %pad : memref<4xf32>, vector<4xf32>
    %vc = arith.addf %va, %vb : vector<4xf32>
    vector.transfer_write %vc, %C[%c0] : vector<4xf32>, memref<4xf32>

    func.return
  }
}
