module sign_extend(Din, Dout);
    input logic [15:0] Din;
    output logic [31:0] Dout;

    assign Dout = {{16{Din[15]}}, Din};
endmodule

// module sign_extend_testbench();
//     logic clk;
//     logic [15:0] Din;
//     logic [31:0] Dout;

//     sign_extend dut(Din, Dout);

//     // Set up the clock
//     parameter CLOCK_PERIOD=100;
// 	initial begin
// 		clk <= 0;
// 		forever #(CLOCK_PERIOD/2) clk <= ~clk;
// 	end

//     initial begin
//         Din <= 16'b1010101010101010; @(posedge clk);
//         @(posedge clk);
//         Din <= 16'b0101010101010101; @(posedge clk);
//         @(posedge clk);
//     $stop;
//     end
// endmodule