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
  reg [31:0] next_pc;
  reg [31:0] pc_add4;
  reg [31:0] counter = 0;    // counter for determine state 
  reg fetch;      // 0: fetching 
  reg read;       // 1: reading
  reg access_mem; // 2: accessing memory 
  reg write;      // 3: write back to reg or mem
  
  // INSTRUCTION LOGICS
  reg [31:0] instruction;

  // REGISTER LOGICS
  // reg [31:0] reg_file [0:31];
  reg [4:0] write_register;
  reg [31:0] write_data;
  reg [31:0] read_data1;
  reg [31:0] read_data2;
  reg [4:0] read_register1;
  reg [4:0] read_register2;

  // CONTROL LOGICS
  reg RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
  reg [1:0] ALUOp;
  reg PCSrc, Zero;
 
  // ALU LOGICS
  reg [31:0] extended_instruction;
  reg [2:0] ALU_ctrl;
  reg [31:0] ALU_in1;
  reg [31:0] left_shifted_signal;
  reg [31:0] ALU_add_result;
  reg [31:0] ALU_regular_result;
  reg overflow, carryout, negative;

  // Data MEMORY LOGICS
  reg [31:0] mem_read_data;

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

  fetch_instructions fetching(.read_address(pc), .enable(fetch), .instruction(instruction));
  mux2_1 select_write_register(.din0(instruction[20:16]), .din1(instruction[15:11]), .sel(RegDst), .mux_out(write_register));
  control control_path(instruction[31:26], RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
  read_register reading(.read_enable(read), .write_enable(write), .read_register1(instruction[25:21]), .read_register2(instruction[20:16]), .write_register(write_register), .write_data(write_data), .reg_write(RegWrite), .read_data1(read_data1), .read_data2(read_data2));
  ALU_control alu_ctrl(instruction[5:0], ALUOp, ALU_ctrl);
  mux2_1 #(32) select_ALU_input(.din0(read_data2), .din1(extended_instruction), .sel(ALUSrc), .mux_out(ALU_in1));
  alu alu_operation(read_data1, ALU_in1, ALU_ctrl, ALU_regular_result, Zero, overflow, carryout, negative);
  data_mem_32 memory(.enable(access_mem), .mem_write(MemWrite), .mem_read(MemRead), .addr(ALU_regular_result), .write_data(read_data2), .read_data(mem_read_data));
  shifter shift_by2(.Din(extended_instruction), .direction(1'b0), .distance(6'b10), .Dout(left_shifted_signal));
  mux2_1 #(32) write_to_reg(.din0(ALU_regular_result), .din1(mem_read_data), .sel(MemtoReg), .mux_out(write_data));
  cpsr_register cpsr(Branch, instruction[31:26], Zero, read_data1, PCSrc);
  
  // Process pc value and its update here
  always @(*) begin
    pc_add4 = pc + 4;
    ALU_add_result = left_shifted_signal + pc_add4;
    // PCSrc = Branch & Zero;
    read_register2 = instruction[20:16];
    read_register1 = instruction[25:21];
    // $display("mem[24]: %b", write_data);
  end

  // update pc value
  mux2_1 #(32) pc_update(.din0(pc_add4), .din1(ALU_add_result), .sel(PCSrc), .mux_out(next_pc));



  // Controls the LED on the board.
  assign led = 1'b1;

  // These are how you communicate back to the serial port debugger.
  assign debug_port1 = pc[7:0];
  assign debug_port2 = instruction[31:24];
  assign debug_port3 = write_register;
  assign debug_port4 = 8'h04;
  assign debug_port5 = 8'h05;
  assign debug_port6 = 8'h06;
  assign debug_port7 = 8'h07;
endmodule
