module ID_Mux
(
  input [4:0] A,
  input [4:0] B,
  input reg2loc_in,
  output reg [4:0] out
);
  always @(A, B, reg2loc_in) begin
    case (reg2loc_in)
        1'b0 : begin
            out <= A;
        end
        1'b1 : begin
            out <= B;
        end
        default : begin
            out <= 1'bx;
        end
    endcase
  end
endmodule

