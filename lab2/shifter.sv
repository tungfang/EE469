module shifter(Din, direction, distance, Dout);
    input logic [31:0] Din;
    input logic direction; // 0: left; 1: right
    input logic [5:0] distance;
    output logic [31:0] Dout;

    always_comb begin
        if (direction == 0) 
            Dout = Din << distance;
        else 
            Dout = Din >> distance;
    end
endmodule

module shifter_testbench();
    logic clk;
    logic [31:0] Din;
    logic direction;
    logic [5:0] distance;
    logic [31:0] Dout;

    shifter dut(Din, direction, distance, Dout);

    // Set up the clock
    parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

    initial begin
        Din <= 31'b1111; direction <= 0; distance <= 5'b00010; @(posedge clk);
        @(posedge clk);
        Din <= 31'b1111; direction <= 1; distance <= 5'b00010; @(posedge clk);
        @(posedge clk);
    $stop;
    end
endmodule