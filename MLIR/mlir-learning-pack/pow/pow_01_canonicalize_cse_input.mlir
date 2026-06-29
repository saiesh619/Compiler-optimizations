// pow_01_canonicalize_cse_input.mlir
// Proof-of-work task: run canonicalization + CSE and explain what changed.
// Try: mlir-opt --canonicalize --cse pow/pow_01_canonicalize_cse_input.mlir

module {
  func.func @redundant_math(%x: i32) -> i32 {
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32

    // x + 0 should canonicalize to x.
    %a = arith.addi %x, %c0 : i32

    // x * 1 should canonicalize to x.
    %b = arith.muli %a, %c1 : i32

    // Same computation repeated twice. CSE can keep one.
    %c = arith.addi %b, %b : i32
    %d = arith.addi %b, %b : i32
    %e = arith.addi %c, %d : i32

    func.return %e : i32
  }
}
