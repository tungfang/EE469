module Branch
(
  input unconditional_branch_in,
  input conditional_branch_in,
  input alu_main_is_zero,
  output reg PC_src_out
);

	reg conditional_branch_temp;

  always @(unconditional_branch_in, conditional_branch_in, alu_main_is_zero) begin
    conditional_branch_temp <= conditional_branch_in & alu_main_is_zero;
    PC_src_out <= unconditional_branch_in | conditional_branch_temp;
  end
endmodule
