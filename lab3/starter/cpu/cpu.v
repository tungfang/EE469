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




  /* PC and Instruction Logics*/
  reg [31:0] PC = 0;
  wire [31:0] IC;
  wire [31:0] jump_PC;
  wire [31:0] IFID_PC; // pipeline pc
  wire [31:0] IFID_IC; // pipeline instruction counter
  wire PCSrc;
  
  /* Hazard Logics */
  wire Hazard_PCWrite;
  wire Hazard_IFIDWrite;

  /* Data Memory Logics */
  reg [31:0] mem_data_in;
  wire [31:0] mem_data_out;
  wire [31:0] mem_addr;
  wire control_memwrite_out;
  wire control_memread_out; 

  always @(posedge clk) begin
    if (Hazard_PCWrite !== 1) begin  
      if (PC === 64'bx) begin
        PC <= 0;
      end else if (PCSrc == 1) begin
          PC <= jump_PC;
      end else begin
        PC <= PC + 4;
      end
    end
  end

  /* Read from Instruction Memory */
  instruction_memory mem1 (PC, IC);

  /* Read from Data Memory */
  data_memory mem2(mem_addr, mem_data_in, control_memwrite_out, control_memread_out, mem_data_out);

  /* IF: Instruction Fetch */
  IFID fetch_decode(clk, PC, IC);

  /* ID: Instruction Decode */
  wire IDEX_memRead;
  wire [4:0] IDEX_write_reg;
  wire control_mux;
  hazard_detection hd (IDEX_memRead, IDEX_write_reg, IFID_PC, IFID_IC, Hazard_IFIDWrite, Hazard_PCWrite, control_mux);

  /* Control Signal */
  wire [1:0] CONTROL_aluop; // EX
  wire CONTROL_alusrc; // EX
  wire CONTROL_isZeroBranch; // M
  wire CONTROL_isUnconBranch; // M
  wire CONTROL_memRead; // M
  wire CONTROL_memwrite; // M
  wire CONTROL_regwrite; // WB
  wire CONTROL_mem2reg; // WB  
  control ctrl (IFID_IC[31:21], CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg);

  wire [1:0] CONTROL_aluop_wire; // EX
  wire CONTROL_alusrc_wire; // EX
  wire CONTROL_isZeroBranch_wire; // M
  wire CONTROL_isUnconBranch_wire; // M
  wire CONTROL_memRead_wire; // M
  wire CONTROL_memwrite_wire; // M
  wire CONTROL_regwrite_wire; // WB
  wire CONTROL_mem2reg_wire; // WB
  Control_Mux ctrl_mux(CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg, Control_mux_wire, CONTROL_aluop_wire, CONTROL_alusrc_wire, CONTROL_isZeroBranch_wire, CONTROL_isUnconBranch_wire, CONTROL_memRead_wire, CONTROL_memwrite_wire, CONTROL_regwrite_wire, CONTROL_mem2reg_wire);

  wire [4:0] reg2_wire;
  ID_Mux decode_mux(IFID_IC[20:16], IFID_IC[4:0], IFID_IC[28], reg2_wire);

  wire [31:0] reg1_data, reg2_data;
  wire MEMWB_regwrite;
  wire [4:0] MEMWB_write_reg;
  wire [31:0] write_reg_data;
  registers reg_file(clk, IFID_IC[9:5], reg2_wire, MEMWB_write_reg, write_reg_data, MEMWB_regwrite, reg1_data, reg2_data);

  wire [31:0] sign_extend_wire;
  // SignExtend unit4 (IFID_IC, sign_extend_wire);

  wire [1:0] IDEX_aluop;
  wire IDEX_alusrc;
  wire IDEX_isZeroBranch;
  wire IDEX_isUnconBranch;
  wire IDEX_memwrite;
  wire IDEX_regwrite;
  wire IDEX_mem2reg;
  wire [31:0] IDEX_reg1_data;
  wire [31:0] IDEX_reg2_data;
  wire [31:0] IDEX_PC;
  wire [31:0] IDEX_sign_extend;
  wire [10:0] IDEX_alu_control;
  wire [4:0] IDEX_forward_reg1;
  wire [4:0] IDEX_forward_reg2;
  IDEX decode_execute (CLOCK, CONTROL_aluop_wire, CONTROL_alusrc_wire, CONTROL_isZeroBranch_wire, CONTROL_isUnconBranch_wire, CONTROL_memRead_wire, CONTROL_memwrite_wire, CONTROL_regwrite_wire, CONTROL_mem2reg_wire, IFID_PC, reg1_data, reg2_data, sign_extend_wire, IFID_IC[31:21], IFID_IC[4:0], IFID_IC[9:5], reg2_wire, IDEX_aluop, IDEX_alusrc, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, IDEX_PC, IDEX_reg1_data, IDEX_reg2_data, IDEX_sign_extend, IDEX_alu_control, IDEX_write_reg, IDEX_forward_reg1, IDEX_forward_reg2);

  /* Execute */
  wire [31:0] left_shifted_wire;
  wire [31:0] PC_jump;
  wire ZERO;
  wire [4:0] EXMEM_write_reg;
  wire EXMEM_regwrite;
  wire EXMEM_mem2reg;
  wire [1:0] Forward_A;
  wire [1:0] Forward_B;

  Left_Shifter left_shift (IDEX_sign_extend, left_shifted_wire);
  ALU alu1 (INDEX_PC, left_shifted_wire, 4'b0010, PC_jump, ZERO);

  ForwardingUnit forward_u (IDEX_forward_reg1, IDEX_forward_reg2, EXMEM_write_reg, MEMWB_write_reg, EXMEM_regwrite, MEMWB_regwrite, Forward_A, Forward_B);
  
  wire [31:0] alu_wire_1;
  Forward_ALU_Mux lal1 (IDEX_reg1_data, write_reg_data, mem_address_out, Forward_A, alu_wire_1);

  wire [31:0] alu_wire_2;
  Forward_ALU_Mux lal2 (IDEX_reg2_data, write_reg_data, mem_address_out, Forward_B, alu_wire_2);

  wire [3:0] alu_main_control_wire;
  ALU_Control unit7(IDEX_aluop, IDEX_alu_control, alu_main_control_wire);

  wire [31:0] alu_data2_wire;
  ALU_Mux mux3(alu_wire_2, IDEX_sign_extend, IDEX_alusrc, alu_data2_wire);

  wire alu_main_is_zero;
  wire [31:0] alu_main_result;
  ALU main_alu(alu_wire_1, alu_data2_wire, alu_main_control_wire, alu_main_result, alu_main_is_zero);

  wire EXMEM_alu_zero;
  wire EXMEM_isZeroBranch;
  wire EXMEM_isUnconBranch;
  EXMEM cache3(clk, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, PC_jump, alu_main_is_zero, alu_main_result, IDEX_reg2_data, IDEX_write_reg, EXMEM_isZeroBranch, EXMEM_isUnconBranch, control_memread_out, control_memwrite_out, EXMEM_regwrite, EXMEM_mem2reg, jump_PC, EXMEM_alu_zero, mem_address_out, mem_data_out, EXMEM_write_reg);

  /* MEM: Memory */
  Branch b(EXMEM_isUnconBranch, EXMEM_isZeroBranch, EXMEM_alu_zero, PCSrc);

  wire [31:0] MEMWB_addr;
  wire [31:0] MEMWB_read_data;
  MEMWB memory_writeback(clk, mem_address_out, mem_data_in,  EXMEM_write_reg, EXMEM_regwrite, EXMEM_mem2reg, MEMWB_address, MEMWB_read_data, MEMWB_write_reg, MEMWB_regwrite, MEMWB_mem2reg);

  /* WB: Write Back*/
  WB_mux writeback_mux(MEMWB_addr, MEMWB_read_data, MEMWB_mem2reg, write_reg_data);

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

    cpu dut(clk, nreset, led, debug_port1, debug_port2, debug_port3, debug_port4, debug_port5, debug_port6, debug_port7);

    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end


    initial begin
        nreset = 0; @(posedge clk);
        nreset = 1; @(posedge clk); @(posedge clk); @(posedge clk);
        nreset = 0; @(posedge clk);
        @(posedge clk); @(posedge clk); @(posedge clk);@(posedge clk); @(posedge clk); @(posedge clk);
        @(posedge clk); @(posedge clk); @(posedge clk);@(posedge clk); @(posedge clk); @(posedge clk);
        @(posedge clk); @(posedge clk); @(posedge clk);@(posedge clk); @(posedge clk); @(posedge clk);
    $stop;
    end
    
endmodule
