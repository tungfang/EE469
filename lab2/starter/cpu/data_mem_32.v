module data_mem_32 #(parameter ADDR_WIDTH = 32, parameter DATA_WIDTH = 32) (enable, mem_write, mem_read, addr, write_data, read_data);

	`include "constants_32.v"
	input enable;
	input mem_write, mem_read;
	input [ADDR_WIDTH - 1:0] addr;
	input [DATA_WIDTH - 1:0] write_data;
	output reg [DATA_WIDTH - 1:0] read_data;

	reg [31:0] data_mem [0:63];

	// read txt file and store 32 data to data memory (initial to 0)
	initial begin
		$readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/data_memory.txt", data_mem);
		// $display("Write To DATA MEM");
	end

	reg [ADDR_WIDTH - 1:0] addr_aligned; // what is this for?

	always @(*) begin
		if (enable) begin
			// read
			read_data = 'b0;
			if (mem_read) begin
				read_data = data_mem[addr];
			end
			// write
			if (mem_write) begin
				data_mem[addr] = write_data;
				// $display("storing data...");
				// $display("data_memory[26]: %b", data_mem[26]);
			end
			// $display("mem[25]: %b", data_mem[25]);
		end
		// $display("mem[24]: %b", data_mem[24]);
	end
	
endmodule

// module data_mem_32_testbench();
// 	reg clk;
// 	reg mem_write, mem_read;
// 	reg [31:0] addr;
// 	reg [31:0] write_data;
// 	reg [31:0] read_data;

// 	data_mem_32 dut(mem_write, mem_read, addr, write_data, read_data);

// 	// Set up the clock
//     parameter CLOCK_PERIOD=100;
//         initial begin
//             clk <= 0;
//             forever #(CLOCK_PERIOD/2) clk <= ~clk;
//         end
	
// 	initial begin
//         mem_read <= 0; mem_write <= 0; @(posedge clk);
//         @(posedge clk);
//         addr <= 32'b00010; write_data <= 200; @(posedge clk);
// 		mem_write <=  1; @(posedge clk);
// 		mem_write <= 0; @(posedge clk);
// 		mem_read <= 1; @(posedge clk);
//         @(posedge clk);
//     $stop;
//     end
// endmodule

