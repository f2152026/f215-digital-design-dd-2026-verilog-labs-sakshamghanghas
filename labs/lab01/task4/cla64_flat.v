// cla64_flat.v
// 64-bit flat carry-lookahead adder using direct carry equations.

module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [64:1] c;

  // Generate / propagate
  genvar i;

  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate


  // ------------------------------------------------------------
  // Direct carry calculation
  //
  // Each c[k+1] is calculated directly from g and p.
  // There is NO dependence on c[k].
  // ------------------------------------------------------------

  function automatic [64:1] calculate_carries;
    input [63:0] p_in;
    input [63:0] g_in;
    input        cin_in;

    integer k;
    integer j;
    reg product;
    reg carry_value;

    begin
      for (k = 0; k < 64; k = k + 1) begin

        // First term: g[k]
        carry_value = g_in[k];

        // Terms involving g[j]
        product = 1'b1;

        for (j = k - 1; j >= 0; j = j - 1) begin
          product = product & p_in[j + 1];

          carry_value = carry_value |
                        (product & g_in[j]);
        end

        // Final term involving cin
        product = 1'b1;

        for (j = k; j >= 0; j = j - 1) begin
          product = product & p_in[j];
        end

        carry_value = carry_value | (product & cin_in);

        calculate_carries[k + 1] = carry_value;

      end
    end
  endfunction


  // Every carry is generated directly from p, g and cin.
  assign #(2) c = calculate_carries(p, g, cin);

  // Sum
  assign #(2) sum = p ^ {c[63:1], cin};

  // Final carry
  assign #(2) cout = c[64];

endmodule