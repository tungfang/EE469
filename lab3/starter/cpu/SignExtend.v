module SignExtend
(
  input [31:0] inputInstruction,
  output reg [63:0] out
);
  always @(inputInstruction) begin
    if (inputInstruction[31:26] == 6'b000101) begin 
        out[25:0] = inputInstruction[25:0];
        out[63:26] = {64{out[25]}};

    end else if (inputInstruction[31:24] == 8'b10110100) begin 
        out[19:0] = inputInstruction[23:5];
        out[63:20] = {64{out[19]}};

    end else begin 
        out[9:0] = inputInstruction[20:12];
        out[63:10] = {64{out[9]}};
    end
  end
endmodule
