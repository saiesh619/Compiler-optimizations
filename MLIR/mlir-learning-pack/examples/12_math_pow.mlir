// 12_math_pow.mlir
// Goal: if by "pow" you meant power/exponent operations, here are scalar and vector examples.

module {
  // Floating exponent: x^y.
  func.func @powf_scalar(%x: f32, %y: f32) -> f32 {
    %r = math.powf %x, %y : f32
    func.return %r : f32
  }

  // Floating base, integer exponent: x^n.
  func.func @powi_scalar(%x: f32, %n: i32) -> f32 {
    %r = math.fpowi %x, %n : f32, i32
    func.return %r : f32
  }

  // Elementwise vector power: each lane computes base[i]^exp[i].
  func.func @powf_vector(%base: vector<4xf32>, %exp: vector<4xf32>) -> vector<4xf32> {
    %r = math.powf %base, %exp : vector<4xf32>
    func.return %r : vector<4xf32>
  }
}
