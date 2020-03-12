module HazardDetection
(
	input EX_memRead_in,
	input [4:0] EX_write_reg,
	input [63:0] ID_PC,
	input [31:0] ID_IC,
	output reg IFID_write_out,
	output reg PC_Write_out,
	output reg Control_mux_out
);
	always @(*) begin
		if (EX_memRead_in == 1'b1 && ((EX_write_reg === ID_IC[9:5]) || (EX_write_reg === ID_IC[20:16]))) begin
			IFID_write_out <= 1'b1;
			PC_Write_out <= 1'b1;
			Control_mux_out <= 1'b1;

		end else begin
			IFID_write_out <= 1'b0;
			PC_Write_out <= 1'b0;
			Control_mux_out <= 1'b0;
		end

	end
endmodule