// and_beh_before.v
// 2-input AND gate, behavioral style with the delay placed BEFORE the
// assignment (statement waits, then evaluates a & b at that later moment).

module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*)
    #2 y = a & b;

endmodule
