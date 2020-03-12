module Forward_ALU_Mux
(
  input [63:0] reg_ex_in,
  input [63:0] reg_wb_in,
  input [63:0] reg_mem_in,
  input [1:0] forward_control,
  output reg [63:0] out
);
	always @(*) begin
		case (forward_control)
        2'b01 : out <= reg_wb_in;
        2'b10 : out <= reg_mem_in;
        default : out <= reg_ex_in;
      endcase
	end
endmodule

