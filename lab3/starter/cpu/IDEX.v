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

module IDEX_testbench();
    reg clk;
    reg [1:0] aluop_in;
    reg alusrc_in;
    reg isZeroBranch_in;
    reg isUnconBranch_in;
    reg memRead_in;
    reg memwrite_in;
    reg regwrite_in;
    reg mem2reg_in;
    reg [31:0] PC_in;
    reg [31:0] regdata1_in;
    reg [31:0] regdata2_in;
    reg [31:0] sign_extend_in;
    reg [10:0] alu_control_in;
    reg [4:0] write_reg_in;
    reg [4:0] forward_reg_1_in;		// Forwarding
    reg [4:0] forward_reg_2_in;		// Forwarding
    wire [1:0] aluop_out;
    wire   alusrc_out;
    wire   isZeroBranch_out;
    wire   isUnconBranch_out;
    wire   memRead_out;
    wire   memwrite_out;
    wire   regwrite_out;
    wire   mem2reg_out;
    wire   [31:0] PC_out;
    wire   [31:0] regdata1_out;
    wire   [31:0] regdata2_out;
    wire   [31:0] sign_extend_out;
    wire   [10:0] alu_control_out;
    wire   [4:0] write_reg_out;
    wire   [4:0] forward_reg_1_out;		// Forwarding
    wire   [4:0] forward_reg_2_out;		// Forwarding


    IDEX dut(clk, aluop_in, alusrc_in, isZeroBranch_in, isUnconBranch_in, memRead_in, memwrite_in, regwrite_in, mem2reg_in, PC_in, regdata1_in, regdata2_in,
    sign_extend_in, alu_control_in, write_reg_in, forward_reg_1_in, forward_reg_2_in, aluop_out, isZeroBranch_out, isUnconBranch_out, memRead_out, memwrite_out,
    regwrite_out, mem2reg_out, PC_out, regdata1_out, regdata2_out, sign_extend_out, alu_control_out, write_reg_out, forward_reg_1_out, forward_reg_2_out);
    


    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        aluop_in = 2'b00; alusrc_in = 0; isZeroBranch_in = 0; isUnconBranch_in = 0; memRead_in = 0; memwrite_in = 0;
        regwrite_in = 0; PC_in = 0; regdata1_in = 0; regdata2_in = 0; @(posedge clk);
        @(posedge clk); @(posedge clk);
        aluop_in = 2'b11; alusrc_in = 1; isZeroBranch_in = 1; isUnconBranch_in = 1; memRead_in = 1; memwrite_in = 1;
        regwrite_in = 1; PC_in = 4; regdata1_in = 30; regdata2_in = 24; @(posedge clk);
        @(posedge clk); @(posedge clk);
        aluop_in = 2'b01; alusrc_in = 0; isZeroBranch_in = 1; isUnconBranch_in = 0; memRead_in = 1; memwrite_in = 0;
        regwrite_in = 1; PC_in = 8; regdata1_in = 8; regdata2_in = 12; @(posedge clk);
        @(posedge clk); @(posedge clk); @(posedge clk);
    $stop;
    end
endmodule
