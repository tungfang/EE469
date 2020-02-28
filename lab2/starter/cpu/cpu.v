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
  reg [3:0] counter = 0;    // counter for determine state 
  reg fetch, read, access_mem, write;      // 0: fetching 
  
  // INSTRUCTION LOGICS
  reg [31:0] instruction;

  // REGISTER LOGICS
  // reg [31:0] reg_file [0:31];
  reg [4:0] write_register;
  reg [31:0] write_data;
  reg [31:0] read_data1;
  reg [31:0] read_data2;

  // CONTROL LOGICS
  reg RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
  reg [1:0] ALUOp;
  reg PCSrc, Zero, start;

  // ALU LOGICS
  reg [31:0] extended_instruction;
  reg [2:0] ALU_ctrl;
  reg [31:0] ALU_in1;
  // reg [31:0] left_shifted_signal;
  // reg [31:0] ALU_add_result;
  reg [31:0] ALU_regular_result;
  reg overflow, carryout, negative;

  // Data MEMORY LOGICS
  reg [31:0] mem_read_data;

    always @(posedge clk) begin
    if (nreset == 1) begin
      pc <= 0;
      counter <= 0;
      start <= 1;
    end
    if (pc < 4) start <= 1; else start <= 0;
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

  fetch_instructions fetching(pc, fetch, instruction);
  mux2_1 select_write_register(instruction[20:16], instruction[15:11], RegDst, write_register);
  control control_path(instruction[31:26], RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
  read_register reading(read, write, instruction[25:21], instruction[20:16], write_register, write_data, RegWrite, read_data1, read_data2, start);
  sign_extend sing_extending(instruction[15:0], extended_instruction);
  ALU_control alu_ctrl(instruction[5:0], ALUOp, ALU_ctrl);
  mux2_1 #(32) select_ALU_input(read_data2, extended_instruction, ALUSrc, ALU_in1);
  alu alu_operation(read_data1, ALU_in1, ALU_ctrl, ALU_regular_result, Zero, overflow, carryout, negative);
  data_mem_32 memory(access_mem, MemWrite, MemRead, ALU_regular_result, read_data2, mem_read_data);  
  // shifter shift_by2(extended_instruction, 1'b0, 2'b10, left_shifted_signal);
  mux2_1 #(32) write_to_reg(ALU_regular_result, mem_read_data, MemtoReg, write_data);
  cpsr_register cpsr(Branch, instruction[31:26], Zero, read_data1, PCSrc);
  
  // Process pc value and its update here
  always @(*) begin
    pc_add4 = pc + 4;
    
    // ALU_add_result = left_shifted_signal + pc_add4;
    // PCSrc = Branch & Zero;
  end

  // update pc value
  mux2_1 #(32) pc_update(pc_add4, ((extended_instruction << 2'b10) + pc_add4), PCSrc, next_pc);

  // Controls the LED on the board.
  assign led = 1'b1;

  // These are how you communicate back to the serial port debugger.
  assign debug_port1 = pc;
  assign debug_port2 = instruction[31:26]; // instruction type
  assign debug_port3 = instruction[25:21]; // Read register1
  assign debug_port4 = read_data1[7:0];  
  assign debug_port5 = instruction[20:16]; // Read register2
  assign debug_port6 = read_data2[7:0];
  assign debug_port7 = write_data[7:0];
    
endmodule
