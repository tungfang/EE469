// Charles Tung Fang, Parsons Choi
// 2020/2/12
// EE 469 Lab 2
// cpu module instantiate every other sub modules

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
  logic [31:0] next_pc;
  logic [31:0] pc_add4;
  logic [31:0] counter = 0;    // counter for determine state 
  logic fetch;      // 0: fetching 
  logic read;       // 1: reading
  logic access_mem; // 2: accessing memory 
  logic write;      // 3: write back to logic or mem
  
  // INSTRUCTION LOGICS
  logic [31:0] instruction_memory [0:12];
  logic [31:0] instruction;

  // read txt file and store inst to instruction
  initial begin
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/instruction_memory.txt", instruction_memory);
  end

  // REGISTER LOGICS
  logic [31:0] reg_file [0:31];
  logic [4:0] write_register;
  logic [31:0] write_data;
  logic [31:0] read_data1;
  logic [31:0] read_data2;

  // read txt file and store 32 registers to register file
  initial begin
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/reg_file.txt", reg_file);
  end

  // DATA MEMORY LOGICS
  logic [31:0] data_mem [0:31];

  // read txt file and store 32 data to data memory (initial to 0)
  initial begin
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/data_memory.txt", data_mem);
  end

  // CONTROL LOGICS
  logic RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
  logic [1:0] ALUOp;
  logic PCSrc, Zero;
 
  // OTHER LOGICS
  logic [31:0] extended_instruction;
  logic [2:0] ALU_ctrl;
  logic [31:0] ALU_in1;
  logic [31:0] left_shifted_signal;
  logic [31:0] ALU_add_result;
  logic[31:0] ALU_regular_result;
  
  always @(posedge clk) begin
    if (nreset == 1) begin
      pc <= 0;
      counter <= 0;
    end
    // Determine which cycle are we in currently 
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
      pc <= next_pc;
    end
    counter <= counter + 1;
  end

  fetch_instructions fetching(.instruction_memory(instruction_memory), .read_address(pc), .enable(fetch), .instruction(instruction));
  mux2_1 select_write_register(.din0(instruction[20:16]), .din1(instruction[15:11]), .sel(logicDst), .mux_out(write_register));
  control control_path(instruction[31:26], RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
  read_register reading(.reg_file, .read_register1(instruction[25:21]), .read_register2(instruction[20:16]), .write_register, .write_data, .reg_write(RegWrite), .read_data1, .read_data2);
  
  sign_extend sign_extending(.Din(instruction[15:0]), .Dout(extended_instruction));
  ALU_control alu_ctrl(.function_code(instruction[5:0]), .ALUOp, .ALU_ctrl);
  mux2_1 #(32) select_ALU_input(.din0(read_data2), .din1(extended_instruction), .sel(ALUSrc), .mux_out(ALU_in1));
  
  shifter shift_by2(.Din(extended_instruction), .direction(1'b0), .distance(6'b10), .Dout(left_shifted_signal));

  // Process pc value and its update here
  always_comb begin
    pc_add4 = pc + 4;
    ALU_add_result = left_shifted_signal + pc_add4;
    PCSrc = Branch & Zero;
  end

  // update pc value
  mux2_1 #(32) pc_update(.din0(pc_add4), .din1(ALU_add_result), .sel(PCSrc), .mux_out(next_pc));


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
