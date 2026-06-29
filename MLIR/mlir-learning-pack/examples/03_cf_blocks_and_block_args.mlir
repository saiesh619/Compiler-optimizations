// 03_cf_blocks_and_block_args.mlir
// Goal: learn CFG blocks and MLIR's block-argument style instead of phi nodes.

module {
  func.func @select_i32_with_cf(%cond: i1, %x: i32, %y: i32) -> i32 {
    cf.cond_br %cond, ^then, ^else

  ^then:
    // Branch to merge and pass %x as the merge block's argument.
    cf.br ^merge(%x : i32)

  ^else:
    %twice_y = arith.addi %y, %y : i32
    cf.br ^merge(%twice_y : i32)

  ^merge(%chosen: i32):
    %one = arith.constant 1 : i32
    %answer = arith.addi %chosen, %one : i32
    func.return %answer : i32
  }
}
