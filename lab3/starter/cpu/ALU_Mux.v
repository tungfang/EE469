module ALU_Mux
(
  input [63:0] a,
  input [63:0] b,
  input CONTROL_ALUSRC,
  output reg [63:0] out
);
  always @(a, b, CONTROL_ALUSRC, out) begin
    if (CONTROL_ALUSRC === 0) begin
      out <= a;
    end

    else begin
      out <= b;
    end
  end
endmodule

