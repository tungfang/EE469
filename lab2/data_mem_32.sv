module data_mem_32 #(parameter ADDR_WIDTH = 32, parameter DATA_WIDTH = 32) (clk, mem_write, mem_read, addr, write_data, read_data);

	`include "constants_32.sv"
	
	input logic clk, mem_write, mem_read;
	input logic [ADDR_WIDTH - 1:0] addr;
	input logic [DATA_WIDTH - 1:0] write_data;
	output logic [DATA_WIDTH - 1:0] read_data;

	logic [DATA_WIDTH - 1:0] mem [0:ADDR_WIDTH - 1];

	logic [ADDR_WIDTH - 1:0] addr_aligned;

	// Read
	always @(*) begin
		read_data = 'b0;
		if (mem_read) begin
			read_data = mem[addr];
		end
	end
	
	// Write
	always @(posedge clk) begin
		if (mem_write) begin
			mem[addr] = write_data;
		end
	end
	
endmodule

module data_mem_32_testbench();
	logic clk, mem_write, mem_read;
	logic [31 - 1:0] addr;
	logic [31 - 1:0] write_data;
	logic [31 - 1:0] read_data;

	data_mem_32 dut(clk, mem_write, mem_read, addr, write_data, read_data);

	// Set up the clock
    parameter CLOCK_PERIOD=100;
        initial begin
            clk <= 0;
            forever #(CLOCK_PERIOD/2) clk <= ~clk;
        end
	
	initial begin
        mem_read <= 0; mem_write <= 0; @(posedge clk);
        @(posedge clk);
        addr <= 32'b01010101010011010111001011011010; write_data <= 200;     
		@(posedge clk);
		mem_write <=  1;
        @(posedge clk);
		mem_write <= 0;
        @(posedge clk);
		mem_read <= 1;
        @(posedge clk);
        @(posedge clk);
    $stop;
    end
endmodule

