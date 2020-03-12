module Left_Shifter(input [31:0] din, output reg [31:0] dout);
    always@(din) begin
        dout <= din << 2;
    end
endmodule
