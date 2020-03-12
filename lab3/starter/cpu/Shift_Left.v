module Shift_Left
(
  input [63:0] data_in,
  output reg [63:0] data_out
);
  always @(data_in) begin
    data_out <= data_in << 2;
  end
endmodule

