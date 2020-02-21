// Charles Tung Fang, Parsons Choi
// 2020/2/11
// EE 469 Lab 2
// fetch the instruction from instruction memory 

module fetch_instructions(read_address, enable, instruction);
    input logic [31:0] read_address;
    input logic enable;
    output logic [31:0] instruction;
    logic [31:0] instruction_memory [0:12];

    // read txt file and store inst to instruction
    initial begin
        $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/instruction_memory.txt", instruction_memory);
    end

    // integer i;
    always_comb begin
	    if (enable) instruction = instruction_memory[read_address >> 2];      
    end

endmodule

module fetch_instructions_testbench();
  logic clk;
  logic [31:0] read_address;
  logic enable;
  logic [31:0] instruction;
  logic [31:0] instruction_memory [0:12];

  fetch_instructions dut(instruction_memory, read_address, enable, instruction);

  // Set up the clock
  parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

  initial begin
    enable <= 0;       @(posedge clk);
    enable <= 1;       @(posedge clk);
    read_address <= 0; @(posedge clk);
                       @(posedge clk);
    read_address <= 4; @(posedge clk);
    @(posedge clk);
  $stop;
  end    
endmodule
