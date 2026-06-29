// pow_01_expected_after.mlir
// Conceptual simplified result after canonicalize + CSE.
// Your exact printed SSA names may differ.

module {
  func.func @redundant_math(%x: i32) -> i32 {
    %sum = arith.addi %x, %x : i32
    %answer = arith.addi %sum, %sum : i32
    func.return %answer : i32
  }
}
