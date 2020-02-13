module test(clk, memory);
    input logic clk;
    output [31:0] memory [0:63];

    initial begin
        $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab1/reg_file.txt", memory);
    end
    assign memory[2] = memory[0] + memory[1];
endmodule


module test_testbench();
    logic clk;
    reg [31:0] memory [0:63];

    test dut(clk, memory);

    // Set up the clock
    parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

    initial begin
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
    $stop;
    end
endmodule