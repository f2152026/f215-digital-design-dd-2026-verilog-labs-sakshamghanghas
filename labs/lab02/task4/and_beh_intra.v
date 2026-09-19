// and_beh_intra.v
// 2-input AND gate, behavioral style with an INTRA-assignment delay (a & b is
// evaluated now, only the write into y is delayed).

module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*)
    y = #2 a & b;

endmodule
