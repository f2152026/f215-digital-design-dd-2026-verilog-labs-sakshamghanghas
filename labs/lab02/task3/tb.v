// tb.v
// Self-checking testbench for the 2-bit magnitude comparator comp2.
// For every input pair it computes the expected GT/LT/EQ independently and
// compares against the DUT, keeping a running error count.

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i, j;
  integer errors = 0;
  reg exp_gt, exp_lt, exp_eq;
  initial begin
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0]; t_b = j[1:0];
        exp_gt = (i >  j);
        exp_lt = (i <  j);
        exp_eq = (i == j);
        #5;
        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    $write("Summary: ");
    if (errors == 0) $display("ALL_COMP2_TESTS_PASSED (16/16 combinations passed)");
    else             $display("%0d of 16 combinations FAILED", errors);
    $finish;
  end

endmodule
