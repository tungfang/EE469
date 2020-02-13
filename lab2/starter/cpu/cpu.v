module cpu(
  input wire clk,
  input wire nreset,
  output wire led,
  output wire [7:0] debug_port1,
  output wire [7:0] debug_port2,
  output wire [7:0] debug_port3,
  output wire [7:0] debug_port4,
  output wire [7:0] debug_port5,
  output wire [7:0] debug_port6,
  output wire [7:0] debug_port7
  );

  // Action Logics below
  reg [31:0] pc = 0;
  reg [31:0] counter = 0;    // counter for determine state 
  reg fetch;      // 0: fetching 
  reg read;       // 1: reading
  reg access_mem; // 2: accessing memory 
  reg write;      // 3: write back to reg or mem
  
  // Instruction logic
  reg [32*13-1:0] instruction_memory;
  reg [31:0] instruction;

  load_instruction_memory load_isa_mem(clk, instruction_memory);

  // Register Logic
  reg [32*32-1:0] reg_file;
  reg[31:0] write_register;
  reg[31:0] read_data1;
  reg[31:0] read_data2;

  load_register_file load_reg(clk, reg_file);

  always @(posedge clk) begin
    if (nreset == 0) begin
      pc <= 0;
      counter <= 0;
    end
    if (counter % 4 == 0) begin 
      fetch <= 1;
      read <= 0;
      access_mem <= 0;
      write <= 0;
    end else if (counter % 4 == 1) begin 
      fetch <= 0;
      read <= 1;
      access_mem <= 0;
      write <= 0;
    end else if (counter % 4 == 2) begin
      fetch <= 0;
      read <= 0;
      access_mem <= 1;
      write <= 0;
    end else begin
      fetch <= 0;
      read <= 0;
      access_mem <= 0;
      write <= 1;
      pc <= pc + 4; // still need to consider for branching
    end
    counter <= counter + 1;
  end

  fetch_instructions fetching(instruction_memory, pc, fetch, instruction);
  mux2_1 select_write_register(instruction[20:16], instruction[15:11], RegDst, write_register);
  read_register reading(clk, reg_file, instruction[25:21], instruction[20:16], write_register, write_data, reg_write, read_data1, read_data2);
  


  // Controls the LED on the board.
  assign led = 1'b1;

  // These are how you communicate back to the serial port debugger.
  assign debug_port1 = 8'h01;
  assign debug_port2 = 8'h02;
  assign debug_port3 = 8'h03;
  assign debug_port4 = 8'h04;
  assign debug_port5 = 8'h05;
  assign debug_port6 = 8'h06;
  assign debug_port7 = 8'h07;
    
endmodule

module cpu_testbench();
  reg clk;
  reg nreset;
  wire led;
  wire [7:0] debug_port1;
  wire [7:0] debug_port2;
  wire [7:0] debug_port3;
  wire [7:0] debug_port4;
  wire [7:0] debug_port5;
  wire [7:0] debug_port6;
  wire [7:0] debug_port7;

  cpu dut (clk, nreset, led, debug_port1, debug_port2, debug_port3, debug_port4, debug_port5, debug_port6, debug_port7);

  // Set up the clock
  parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

  initial begin
    nreset <= 1; @(posedge clk);
    nreset <= 0; @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
  $stop;
  end

endmodule
