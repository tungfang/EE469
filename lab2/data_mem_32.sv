module data_mem_32 #(parameter ADDR_WIDTH = 32, parameter DATA_WIDTH = 32) (mem_write, mem_read, addr, write_data, read_data, data_memory);

	`include "constants_32.sv"
	
	input logic mem_write, mem_read;
	input logic [ADDR_WIDTH - 1:0] addr;
	input logic [DATA_WIDTH - 1:0] write_data;
	output logic [DATA_WIDTH - 1:0] read_data;
	output logic [31:0] data_memory [0:31];

	// logic [DATA_WIDTH - 1:0] mem [0:ADDR_WIDTH - 1];

	logic [ADDR_WIDTH - 1:0] addr_aligned; // what is this for?

	always_comb begin
		// read
		read_data = 'b0;
		if (mem_read) begin
			read_data = data_memory[addr];
		end
		// write
		if (mem_write) begin
			data_memory[addr] = write_data;
			$display("storing data...");
			$display("data_memory[%b]: %b", addr, data_memory[addr]);
		end

	end
	
endmodule

module data_mem_32_testbench();
	logic clk;
	logic mem_write, mem_read;
	logic [31:0] addr;
	logic [31:0] write_data;
	logic [31:0] read_data;
	logic [31:0] data_memory [0:31];

	data_mem_32 dut(mem_write, mem_read, addr, write_data, read_data, data_memory);

	// Set up the clock
    parameter CLOCK_PERIOD=100;
        initial begin
            clk <= 0;
            forever #(CLOCK_PERIOD/2) clk <= ~clk;
        end
	
	initial begin
        mem_read <= 0; mem_write <= 0; @(posedge clk);
        @(posedge clk);
        addr <= 32'b00010; write_data <= 200; @(posedge clk);
		mem_write <=  1; @(posedge clk);
		mem_write <= 0; @(posedge clk);
		mem_read <= 1; @(posedge clk);
        @(posedge clk);
    $stop;
    end
endmodule

