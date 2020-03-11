module ALU (
  input [63:0] Bus_A,
  input [63:0] Bus_B,
  input [3:0] control,
  output reg [63:0] out,
  output reg ZERO
);
  always @(*) begin
    case (control)
      4'b0000 : out = Bus_A & Bus_B;
      4'b0001 : out = Bus_A | Bus_B;
      4'b0010 : out = Bus_A + Bus_B;
      4'b0110 : out = Bus_A - Bus_B;
      4'b0111 : out = Bus_B;
      4'b1100 : out = ~(Bus_A | Bus_B);
      default : out = 64'hxxxxxxxx;
    endcase

    if (out == 0) begin
      ZERO = 1'b1;
    end else if (out != 0) begin
      ZERO = 1'b0;
    end else begin
      ZERO = 1'bx;
    end
    
  end
endmodule