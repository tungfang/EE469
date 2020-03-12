module Branch
(
  input unconditional_branch_in,
  input conditional_branch_in,
  input alu_zero,
  output reg PCSrc
);

	reg conditional_branch_temp;

  always @(unconditional_branch_in, conditional_branch_in, alu_zero) begin
    conditional_branch_temp <= conditional_branch_in & alu_zero;
    PCSrc <= unconditional_branch_in | conditional_branch_temp;
  end
endmodule
