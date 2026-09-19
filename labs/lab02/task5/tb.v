// tb.v
// Self-checking testbench for the 1-bit-opcode ALU (op=0 add, op=1 sub).
// Exercises both operations with a fixed operand pair while toggling op
// (exposes the sensitivity-list bug) and with changing operands (exposes the
// blocking/non-blocking bug in the subtract chain).

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer errors = 0;
  reg [3:0] exp;

  task check(input [3:0] a, input [3:0] b, input op);
    begin
      t_a = a; t_b = b; t_op = op;
      #5;
      exp = (op == 1'b0) ? (a + b) : (a - b);
      exp = exp & 4'hF;
      if (t_result !== exp) begin
        $display("FAIL: a=%0d b=%0d op=%b  got result=%0d  expected %0d",
                 a, b, op, t_result, exp);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    // Same operand pair, toggle op only (sensitivity-list check).
    check(4'd5, 4'd3, 1'b0);
    check(4'd5, 4'd3, 1'b1);
    // Subtraction with changing operands (dependency-chain check).
    check(4'd8, 4'd2, 1'b1);
    check(4'd3, 4'd7, 1'b1);
    check(4'd9, 4'd4, 1'b0);
    check(4'd0, 4'd0, 1'b1);

    $write("Summary: ");
    if (errors == 0) $display("ALL_ALU_TESTS_PASSED");
    else             $display("%0d tests FAILED", errors);
    $finish;
  end

  initial
    $monitor($time, " a=%0d b=%0d op=%b | result=%0d", t_a, t_b, t_op, t_result);

endmodule
