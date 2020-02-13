module cpu(
  input logic clk,
  input logic nreset,
  output logic led,
  output logic [7:0] debug_port1,
  output logic [7:0] debug_port2,
  output logic [7:0] debug_port3,
  output logic [7:0] debug_port4,
  output logic [7:0] debug_port5,
  output logic [7:0] debug_port6,
  output logic [7:0] debug_port7
  );

  // Action Logics below
  logic [31:0] pc = 0;
  logic [31:0] counter = 0;    // counter for determine state 
  logic fetch;      // 0: fetching 
  logic read;       // 1: reading
  logic access_mem; // 2: accessing memory 
  logic write;      // 3: write back to logic or mem
  
  // Instruction logic
  logic [31:0] instruction_memory [0:12];
  logic [31:0] instruction;

  initial begin
      // read txt file and store inst to code memory
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/instruction_memory.txt", instruction_memory);
  end

  // register Logic
  logic [31:0] reg_file [0:31];
  logic[4:0] write_register;
  logic[31:0] read_data1;
  logic[31:0] read_data2;
  
  initial begin
      // read txt file and store inst to code memory
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/reg_file.txt", reg_file);
  end

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
  mux2_1 select_write_register(instruction[20:16], instruction[15:11], logicDst, write_register);
  // read_register reading(clk, reg_file, instruction[25:21], instruction[20:16], write_register, write_data, logic_write, read_data1, read_data2);
  


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
  logic clk;
  logic nreset;
  logic led;
  logic [7:0] debug_port1;
  logic [7:0] debug_port2;
  logic [7:0] debug_port3;
  logic [7:0] debug_port4;
  logic [7:0] debug_port5;
  logic [7:0] debug_port6;
  logic [7:0] debug_port7;

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
