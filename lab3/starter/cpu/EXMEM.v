module EXMEM
(
  input clk,
  input isZeroBranch_in, 	// M Stage
  input isUnconBranch_in, 	// M Stage
  input memRead_in, 		// M Stage
  input memwrite_in, 		// M Stage
  input regwrite_in, 		// WB Stage
  input mem2reg_in, 		// WB Stage
  input [63:0] shifted_PC_in,
  input alu_zero_in,
  input [63:0] alu_result_in,
  input [63:0] write_data_mem_in,
  input [4:0] write_reg_in,
  output reg isZeroBranch_out, 	// M Stage
  output reg isUnconBranch_out, // M Stage
  output reg memRead_out, 		// M Stage
  output reg memwrite_out, 		// M Stage
  output reg regwrite_out,		// WB Stage
  output reg mem2reg_out,		// WB Stage
  output reg [63:0] shifted_PC_out,
  output reg alu_zero_out,
  output reg [63:0] alu_result_out,
  output reg [63:0] write_data_mem_out,
  output reg [4:0] write_reg_out
);
	always @(negedge clk) begin
		/* M */
		isZeroBranch_out <= isZeroBranch_in;
		isUnconBranch_out <= isUnconBranch_in;
		memRead_out <= memRead_in;
		memwrite_out <= memwrite_in;

		/* WB */
		regwrite_out <= regwrite_in;
		mem2reg_out <= mem2reg_in;

		/* all Stages */
		shifted_PC_out <= shifted_PC_in;
		alu_zero_out <= alu_zero_in;
		alu_result_out <= alu_result_in;
		write_data_mem_out <= write_data_mem_in;
		write_reg_out <= write_reg_in;
	end
endmodule
