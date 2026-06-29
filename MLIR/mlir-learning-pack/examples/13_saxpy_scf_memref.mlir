// 13_saxpy_scf_memref.mlir
// Goal: a realistic numeric kernel.
// C-like meaning: for i in [0, n): Y[i] = a * X[i] + Y[i]

module {
  func.func @saxpy(%a: f32, %X: memref<?xf32>, %Y: memref<?xf32>, %n: index) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index

    scf.for %i = %c0 to %n step %c1 {
      %x = memref.load %X[%i] : memref<?xf32>
      %y = memref.load %Y[%i] : memref<?xf32>
      %prod = arith.mulf %a, %x : f32
      %next = arith.addf %prod, %y : f32
      memref.store %next, %Y[%i] : memref<?xf32>
    }

    func.return
  }
}
