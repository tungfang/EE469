module ALU_Mux
(
  input [31:0] input1,
  input [31:0] input2,
  input ALUSRC,
  output reg [31:0] out
);
  always @(input1, input2, ALUSRC, out) begin
    if (ALUSRC === 0) begin
      out <= input1;
    end

    else begin
      out <= input2;
    end
  end
endmodule