module IDEX
(
  input clk,
  input [1:0] aluop_in,
  input alusrc_in,
  input isZeroBranch_in,
  input isUnconBranch_in,
  input memRead_in,
  input memwrite_in,
  input regwrite_in,
  input mem2reg_in,
  input [63:0] PC_in,
  input [63:0] regdata1_in,
  input [63:0] regdata2_in,
  input [63:0] sign_extend_in,
  input [10:0] alu_control_in,
  input [4:0] write_reg_in,
  input [4:0] forward_reg_1_in,		// Forwarding
  input [4:0] forward_reg_2_in,		// Forwarding
  output reg [1:0] aluop_out,
  output reg alusrc_out,
  output reg isZeroBranch_out,
  output reg isUnconBranch_out,
  output reg memRead_out,
  output reg memwrite_out,
  output reg regwrite_out,
  output reg mem2reg_out,
  output reg [63:0] PC_out,
  output reg [63:0] regdata1_out,
  output reg [63:0] regdata2_out,
  output reg [63:0] sign_extend_out,
  output reg [10:0] alu_control_out,
  output reg [4:0] write_reg_out,
  output reg [4:0] forward_reg_1_out,		// Forwarding
  output reg [4:0] forward_reg_2_out		// Forwarding
);
  always @(negedge clk) begin
    /* Values for EX */
    aluop_out <= aluop_in;
	  alusrc_out <= alusrc_in;

    /* Values for M */
  	isZeroBranch_out <= isZeroBranch_in;
    isUnconBranch_out <= isUnconBranch_in;
  	memRead_out <= memRead_in;
 	  memwrite_out <= memwrite_in;

    /* Values for WB */
    regwrite_out <= regwrite_in;
  	mem2reg_out <= mem2reg_in;

    /* Values for all Stages */
    PC_out <= PC_in;
    regdata1_out <= regdata1_in;
    regdata2_out <= regdata2_in;

    /* Values for variable stages */
    sign_extend_out <= sign_extend_in;
  	alu_control_out <= alu_control_in;
  	write_reg_out <= write_reg_in;
	  forward_reg_1_out <= forward_reg_1_in;
	  forward_reg_2_out <= forward_reg_2_in;
  end
endmodule
