// 05_memref_alloc_load_store.mlir
// Goal: allocate a buffer, store values, load values, deallocate.

module {
  func.func @fill_four_i32() -> i32 {
    %buf = memref.alloc() : memref<4xi32>

    %i0 = arith.constant 0 : index
    %i1 = arith.constant 1 : index
    %i2 = arith.constant 2 : index
    %i3 = arith.constant 3 : index

    %v10 = arith.constant 10 : i32
    %v20 = arith.constant 20 : i32
    %v30 = arith.constant 30 : i32
    %v40 = arith.constant 40 : i32

    memref.store %v10, %buf[%i0] : memref<4xi32>
    memref.store %v20, %buf[%i1] : memref<4xi32>
    memref.store %v30, %buf[%i2] : memref<4xi32>
    memref.store %v40, %buf[%i3] : memref<4xi32>

    %a = memref.load %buf[%i0] : memref<4xi32>
    %b = memref.load %buf[%i3] : memref<4xi32>
    %sum = arith.addi %a, %b : i32

    memref.dealloc %buf : memref<4xi32>
    func.return %sum : i32
  }
}
