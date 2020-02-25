module shifter(Din, direction, distance, Dout);
    input [31:0] Din;
    input direction; // 0: left; 1: right
    input [5:0] distance;
    output reg [31:0] Dout;

    always @(*) begin
        if (direction == 0) 
            Dout = Din << distance;
        else 
            Dout = Din >> distance;
    end
endmodule

// module shifter_testbench();
//     reg clk;
//     reg [31:0] Din;
//     reg direction;
//     reg [5:0] distance;
//     reg [31:0] Dout;

//     shifter dut(Din, direction, distance, Dout);

//     // Set up the clock
//     parameter CLOCK_PERIOD=100;
// 	initial begin
// 		clk <= 0;
// 		forever #(CLOCK_PERIOD/2) clk <= ~clk;
// 	end

//     initial begin
//         Din <= 31'b1111; direction <= 0; distance <= 5'b00010; @(posedge clk);
//         @(posedge clk);
//         Din <= 31'b1111; direction <= 1; distance <= 5'b00010; @(posedge clk);
//         @(posedge clk);
//     $stop;
//     end
// endmodule