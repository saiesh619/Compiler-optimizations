// 01_arith_and_func.mlir
// Goal: basic arithmetic, comparison, function call.

module {
  func.func @square_i32(%x: i32) -> i32 {
    %sq = arith.muli %x, %x : i32
    func.return %sq : i32
  }

  func.func @mix_arithmetic(%a: i32, %b: i32, %x: f32, %y: f32) -> (i32, f32, i1) {
    %int_sum = arith.addi %a, %b : i32
    %int_sq = func.call @square_i32(%int_sum) : (i32) -> i32

    %float_mul = arith.mulf %x, %y : f32
    %float_sum = arith.addf %float_mul, %x : f32

    // Signed greater-than comparison.
    %is_gt = arith.cmpi sgt, %a, %b : i32

    func.return %int_sq, %float_sum, %is_gt : i32, f32, i1
  }
}
