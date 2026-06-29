// 02_generic_form_and_attrs.mlir
// Goal: understand that pretty syntax is just a custom assembly form.

module attributes {repo.stage = "basics", repo.topic = "generic-operation-form"} {
  func.func @generic_vs_pretty(%a: i32, %b: i32) -> i32 {
    // Pretty/custom form.
    %pretty = arith.addi %a, %b : i32

    // Generic form of a known operation.
    %generic = "arith.addi"(%pretty, %b) : (i32, i32) -> i32

    // Another known operation written in generic form.
    // Unknown generic ops are also possible, but you normally need to allow or register their dialect.
    %c7 = arith.constant 7 : i32
    %scaled = "arith.muli"(%generic, %c7) : (i32, i32) -> i32

    "func.return"(%scaled) : (i32) -> ()
  }
}
