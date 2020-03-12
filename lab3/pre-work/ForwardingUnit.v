module ForwardingUnit
(
	input [4:0] EX_Rn_in,
	input [4:0] EX_Rm_in,
	input [4:0] MEM_Rd_in,
	input [4:0] WB_Rd_in,
	input MEM_regwrite_in,
	input WB_regwrite_in,
	output reg [1:0] A_out,
	output reg [1:0] B_out
);
  always @(*) begin
		if ((WB_regwrite_in == 1) && (WB_Rd_in !== 31) && (WB_Rd_in === EX_Rn_in)) begin
			A_out <= 2'b01;
		end else if ((MEM_regwrite_in == 1) && (MEM_Rd_in !== 31) && (MEM_Rd_in === EX_Rn_in)) begin
			A_out <= 2'b10;
		end else begin
			A_out <= 2'b00;
		end

		if ((WB_regwrite_in == 1'b1) && (WB_Rd_in !== 31) && (WB_Rd_in === EX_Rm_in)) begin
			B_out <= 2'b01;
		end else if ((MEM_regwrite_in == 1'b1) && (MEM_Rd_in !== 31) && (MEM_Rd_in === EX_Rm_in)) begin
			B_out <= 2'b10;
		end else begin
			B_out <= 2'b00;
		end
  end
endmodule