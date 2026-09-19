// and_df.v
// 2-input AND gate, dataflow style with a continuous-assignment delay.

module and_df (
  input  a,
  input  b,
  output y
);

  assign #2 y = a & b;

endmodule
