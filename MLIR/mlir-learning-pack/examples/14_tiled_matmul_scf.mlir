// 14_tiled_matmul_scf.mlir
// Goal: show the loop shape of a manually tiled matmul.
// This is deliberately explicit so you can understand tiling before using transform passes.

module {
  func.func @tiled_matmul_64(
      %A: memref<64x64xf32>,
      %B: memref<64x64xf32>,
      %C: memref<64x64xf32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %c64 = arith.constant 64 : index
    %zero = arith.constant 0.0 : f32

    // Initialize C to zero.
    scf.for %i = %c0 to %c64 step %c1 {
      scf.for %j = %c0 to %c64 step %c1 {
        memref.store %zero, %C[%i, %j] : memref<64x64xf32>
      }
    }

    // Tiled loops: ii/jj/kk choose the tile, i/j/k compute inside the tile.
    scf.for %ii = %c0 to %c64 step %c8 {
      scf.for %jj = %c0 to %c64 step %c8 {
        scf.for %kk = %c0 to %c64 step %c8 {
          scf.for %i0 = %c0 to %c8 step %c1 {
            scf.for %j0 = %c0 to %c8 step %c1 {
              scf.for %k0 = %c0 to %c8 step %c1 {
                %i = arith.addi %ii, %i0 : index
                %j = arith.addi %jj, %j0 : index
                %k = arith.addi %kk, %k0 : index
                %a = memref.load %A[%i, %k] : memref<64x64xf32>
                %b = memref.load %B[%k, %j] : memref<64x64xf32>
                %c = memref.load %C[%i, %j] : memref<64x64xf32>
                %prod = arith.mulf %a, %b : f32
                %sum = arith.addf %c, %prod : f32
                memref.store %sum, %C[%i, %j] : memref<64x64xf32>
              }
            }
          }
        }
      }
    }

    func.return
  }
}
