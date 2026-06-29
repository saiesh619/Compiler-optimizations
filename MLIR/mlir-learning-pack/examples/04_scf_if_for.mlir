// 04_scf_if_for.mlir
// Goal: use structured control flow instead of raw branches.

module {
  func.func @abs_i32(%x: i32) -> i32 {
    %zero = arith.constant 0 : i32
    %is_neg = arith.cmpi slt, %x, %zero : i32

    %result = scf.if %is_neg -> (i32) {
      %neg = arith.subi %zero, %x : i32
      scf.yield %neg : i32
    } else {
      scf.yield %x : i32
    }

    func.return %result : i32
  }

  func.func @sum_0_to_n_minus_1(%n: index) -> index {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index

    // Loop-carried variable: %acc starts at %c0 and becomes %sum after loop exit.
    %sum = scf.for %i = %c0 to %n step %c1 iter_args(%acc = %c0) -> (index) {
      %next = arith.addi %acc, %i : index
      scf.yield %next : index
    }

    func.return %sum : index
  }
}
