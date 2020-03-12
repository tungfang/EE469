module Control_Mux
(
  input [1:0] CONTROL_aluop_in,
  input CONTROL_alusrc_in,
  input CONTROL_isZeroBranch_in,
  input CONTROL_isUnconBranch_in,
  input CONTROL_memRead_in,
  input CONTROL_memwrite_in,
  input CONTROL_regwrite_in,
  input CONTROL_mem2reg_in,
  input mux_control_in,
  output reg [1:0] CONTROL_aluop_out,
  output reg CONTROL_alusrc_out,
  output reg CONTROL_isZeroBranch_out,
  output reg CONTROL_isUnconBranch_out,
  output reg CONTROL_memRead_out,
  output reg CONTROL_memwrite_out,
  output reg CONTROL_regwrite_out,
  output reg CONTROL_mem2reg_out
);
	always @(*) begin
		if (mux_control_in === 1'b1) begin
		  CONTROL_aluop_out <= 2'b00;
		  CONTROL_alusrc_out <= 1'b0;
		  CONTROL_isZeroBranch_out <= 1'b0;
		  CONTROL_isUnconBranch_out <= 1'b0;
		  CONTROL_memRead_out <= 1'b0;
		  CONTROL_memwrite_out <= 1'b0;
		  CONTROL_regwrite_out <= 1'b0;
		  CONTROL_mem2reg_out <= 1'b0;
		end else begin
		  CONTROL_aluop_out <= CONTROL_aluop_in;
		  CONTROL_alusrc_out <= CONTROL_alusrc_in;
		  CONTROL_isZeroBranch_out <= CONTROL_isZeroBranch_in;
		  CONTROL_isUnconBranch_out <= CONTROL_isUnconBranch_in;
		  CONTROL_memRead_out <= CONTROL_memRead_in;
		  CONTROL_memwrite_out <= CONTROL_memwrite_in;
		  CONTROL_regwrite_out <= CONTROL_regwrite_in;
		  CONTROL_mem2reg_out <= CONTROL_mem2reg_in;
		end
	end
endmodule
