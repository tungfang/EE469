module IFID
(
  input clk,
  input [63:0] PC_in,
  input [31:0] IC_in,
  input Hazard_in,
  output reg [63:0] PC_out,
  output reg [31:0] IC_out
);
	always @(negedge clk) begin
		if (Hazard_in !== 1'b1) begin
			PC_out <= PC_in;
			IC_out <= IC_in;
		end
  end
endmodule

/*
module IFID_testbench();
    reg clk;
    reg [31:0] PC_in, IC_in;
    reg Hazard_in;
    wire [31:0] PC_out, IC_out;

    IFID dut(clk, PC_in, IC_in, Hazard_in, PC_out, IC_out);

    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end


    initial begin
        PC_in = 0; IC_in = 0; Hazard_in = 1; @(posedge clk);
        Hazard_in = 0; @(posedge clk); @(posedge clk); @(posedge clk);
        PC_in = 12; IC_in = 12; Hazard_in = 1; @(posedge clk);
        Hazard_in = 0; @(posedge clk); @(posedge clk); @(posedge clk);
    $stop;
    end
    
endmodule
*/