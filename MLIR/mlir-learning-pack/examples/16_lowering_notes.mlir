// 16_lowering_notes.mlir
// Goal: keep one simple example around for lowering experiments.
//
// Useful pipeline experiments:
//   mlir-opt --canonicalize --cse examples/16_lowering_notes.mlir
//   mlir-opt --convert-scf-to-cf examples/16_lowering_notes.mlir
//
// Full lowering to LLVM depends on the dialects used and on your MLIR version.
// Build confidence by lowering one abstraction layer at a time.

module {
  func.func @lowering_friendly(%n: index) -> index {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index

    %result = scf.for %i = %c0 to %n step %c1 iter_args(%acc = %c0) -> (index) {
      %twice = arith.muli %i, %c2 : index
      %next = arith.addi %acc, %twice : index
      scf.yield %next : index
    }

    func.return %result : index
  }
}
