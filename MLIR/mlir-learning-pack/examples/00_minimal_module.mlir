// 00_minimal_module.mlir
// Goal: see the smallest useful MLIR module.
// Run: mlir-opt examples/00_minimal_module.mlir

module {
  // A function is an operation from the func dialect.
  // Arguments and return values are strongly typed.
  func.func @return_constant() -> i32 {
    %c42 = arith.constant 42 : i32
    func.return %c42 : i32
  }

  func.func @add_two_i32(%a: i32, %b: i32) -> i32 {
    %sum = arith.addi %a, %b : i32
    func.return %sum : i32
  }
}
