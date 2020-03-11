module Left_Shifter(input [63:0] din, output reg [63:0] dout);
    always@(din) begin
        dout <= din << 2;
    end
endmodule
