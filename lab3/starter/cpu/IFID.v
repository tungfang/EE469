module IFID
(
  input clk,
  input [63:0] PC_in,
  input [31:0] IC_in,
  input Hazard_in,
  output reg [63:0] PC_out,
  output reg [31:0] IC_out
);
	always @(negedge clk) begin
		if (Hazard_in !== 1'b1) begin
			PC_out <= PC_in;
			IC_out <= IC_in;
		end
  end
endmodule