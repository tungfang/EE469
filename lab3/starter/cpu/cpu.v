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

    reg[63:0] PC;
    wire[31:0] Instruction;

    /* Instruction Logics */
    wire PCSrc;
    wire [63:0] PC_jump;
    wire [63:0] IFID_PC;
    wire [31:0] IFID_IC;
    
    // Data Mem Logics
    wire[63:0] mem_addr;
    wire control_memwrite;
    wire control_memread;
    reg[63:0] mem_data_in;
    wire[63:0] mem_data_out;
    
    /* Hazard Logics */
  	wire Hazard_PCWrite;
	  wire Hazard_IFIDWrite;

    /* Instruction Decode Logics */
    wire IDEX_memRead;
    wire [4:0] IDEX_write_reg;
    wire Control_mux;

    /* Control Logics */
    wire [1:0] CTRL_aluop; // EX
    wire CTRL_alusrc; // EX
    wire CTRL_isZeroBranch; // M
    wire CTRL_isUnconBranch; // M
    wire CTRL_memRead; // M
    wire CTRL_memwrite; // M
    wire CTRL_regwrite; // WB
    wire CTRL_mem2reg; // WB
    wire [1:0] CTRL_aluop_wire; // EX
    wire CTRL_alusrc_wire; // EX
    wire CTRL_isZeroBranch_wire; // M
    wire CTRL_isUnconBranch_wire; // M
    wire CTRL_memRead_wire; // M
    wire CTRL_memwrite_wire; // M
    wire CTRL_regwrite_wire; // WB
    wire CTRL_mem2reg_wire; // WB

    /* Registers Logics */
    wire [4:0] reg2_addr;
    wire [63:0] reg1_data, reg2_data;
    wire MEMWB_regwrite;
    wire [4:0] MEMWB_write_reg;
    wire [63:0] write_reg_data;

    /* Sign Extend Logic */
    wire [63:0] sign_extend_wire;

    /* Instruction Decode -> Execute Logic */
    wire [1:0] IDEX_aluop;
    wire IDEX_alusrc;
    wire IDEX_isZeroBranch;
    wire IDEX_isUnconBranch;
    wire IDEX_memwrite;
    wire IDEX_regwrite;
    wire IDEX_mem2reg;
    wire [63:0] IDEX_reg1_data;
    wire [63:0] IDEX_reg2_data;
    wire [63:0] IDEX_PC;
    wire [63:0] sign_extended;
    wire [10:0] IDEX_alu_control;
    wire [4:0] IDEX_forward_reg1;
    wire [4:0] IDEX_forward_reg2;

    /* Execute Logics */
    wire [63:0] left_shifted;
    wire [63:0] jump_PC;
    wire jump_is_zero;
    wire [4:0] EXMEM_write_reg;
    wire EXMEM_regwrite;
    wire EXMEM_mem2reg;
    wire [1:0] Forward_A;
    wire [1:0] Forward_B;

    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    /* Instruction Memory */
    IC instruction_memory (PC, Instruction);

    /* Data Memory */
    Data_Memory data_memory (mem_addr, mem_data_in, control_memwrite, control_memread, mem_data_out);


    /* IF : Instruction Fetch */
    IFID cache1 (clk, PC, Instruction, Hazard_IFIDWrite, IFID_PC, IFID_IC);

    always @(posedge clk) begin
      if (Hazard_PCWrite !== 1'b1) begin
        if (PC === 64'bx) begin
          PC <= 0;
        end else if (PCSrc == 1'b1) begin
          PC <= PC_jump;
        end else begin
          PC <= PC + 4;
        end
      end
    end


    /* ID : Instruction Decode */
    HazardDetection HD (IDEX_memRead, IDEX_write_reg, IFID_PC, IFID_IC, Hazard_IFIDWrite, Hazard_PCWrite, Control_mux);
    
    ARM_Control arm_control (IFID_IC[31:21], CTRL_aluop, CTRL_alusrc, CTRL_isZeroBranch, CTRL_isUnconBranch, CTRL_memRead, CTRL_memwrite, CTRL_regwrite, CTRL_mem2reg);
    
    Control_Mux control_mux(CTRL_aluop, CTRL_alusrc, CTRL_isZeroBranch, CTRL_isUnconBranch, CTRL_memRead, CTRL_memwrite, CTRL_regwrite, CTRL_mem2reg, Control_mux, CTRL_aluop_wire, CTRL_alusrc_wire, CTRL_isZeroBranch_wire, CTRL_isUnconBranch_wire, CTRL_memRead_wire, CTRL_memwrite_wire, CTRL_regwrite_wire, CTRL_mem2reg_wire);
    
    ID_Mux decode_mux(IFID_IC[20:16], IFID_IC[4:0], IFID_IC[28], reg2_addr);

    Registers registers(clk, IFID_IC[9:5], reg2_addr, MEMWB_write_reg, write_reg_data, MEMWB_regwrite, reg1_data, reg2_data);

    SignExtend sign_extend(IFID_IC, sign_extend_wire);

    IDEX decode_execute(clk, CTRL_aluop_wire, CTRL_alusrc_wire, CTRL_isZeroBranch_wire, CTRL_isUnconBranch_wire, CTRL_memRead_wire, CTRL_memwrite_wire, CTRL_regwrite_wire, CTRL_mem2reg_wire, IFID_PC, reg1_data, reg2_data, sign_extend_wire, IFID_IC[31:21], IFID_IC[4:0], IFID_IC[9:5], reg2_addr, IDEX_aluop, IDEX_alusrc, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, IDEX_PC, IDEX_reg1_data, IDEX_reg2_data, sign_extended, IDEX_alu_control, IDEX_write_reg, IDEX_forward_reg1, IDEX_forward_reg2);


    /* EX : Execute */
    Shift_Left shift_left(sign_extended, left_shifted);
    
    ALU alu(IDEX_PC, left_shifted, 4'b0010, jump_PC, jump_is_zero);

    ForwardingUnit forward(IDEX_forward_reg1, IDEX_forward_reg2, EXMEM_write_reg, MEMWB_write_reg, EXMEM_regwrite, MEMWB_regwrite, Forward_A, Forward_B);

    wire [63:0] alu_1_wire;
    wire [63:0] alu_2_wire;
    Forward_ALU_Mux FAM1(IDEX_reg1_data, write_reg_data, mem_addr, Forward_A, alu_1_wire);
    Forward_ALU_Mux FAM2(IDEX_reg2_data, write_reg_data, mem_addr, Forward_B, alu_2_wire);

    wire [3:0] alu_main_control_wire;
    ALU_Control alu_ctrl(IDEX_aluop, IDEX_alu_control, alu_main_control_wire);

    wire [63:0] alu_data2_wire;
    ALU_Mux alu_mux(alu_2_wire, sign_extended, IDEX_alusrc, alu_data2_wire);

    wire alu_main_is_zero;
    wire [63:0] alu_main_result;
    ALU alu_main(alu_1_wire, alu_data2_wire, alu_main_control_wire, alu_main_result, alu_main_is_zero);

    wire EXMEM_isZeroBranch;
    wire EXMEM_isUnconBranch;
    wire EXMEM_alu_zero;
    EXMEM execute_memory(clk, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, jump_PC, alu_main_is_zero, alu_main_result, IDEX_reg2_data, IDEX_write_reg, EXMEM_isZeroBranch, EXMEM_isUnconBranch, control_memread, control_memwrite, EXMEM_regwrite, EXMEM_mem2reg, PC_jump, EXMEM_alu_zero, mem_addr, mem_data_out, EXMEM_write_reg);


    /* MEM : Memory */
    Branch b(EXMEM_isUnconBranch, EXMEM_isZeroBranch, EXMEM_alu_zero, PCSrc);

    wire [63:0] MEMWB_addr;
    wire [63:0] MEMWB_read_data;
    MEMWB memory_writeback(clk, mem_addr, mem_data_in, EXMEM_write_reg, EXMEM_regwrite, EXMEM_mem2reg, MEMWB_addr, MEMWB_read_data, MEMWB_write_reg, MEMWB_regwrite, MEMWB_mem2reg);


    /* WB : Writeback */
    WB_Mux writeback_mux(MEMWB_addr, MEMWB_read_data, MEMWB_mem2reg, write_reg_data);

    wire [7:0] test = 8'b10101010;
    // Controls the LED on the board.
    assign led = 1'b1;

    // These are how you communicate back to the serial port debugger.
    assign debug_port1 = PC; 
    assign debug_port2 = Instruction;
    assign debug_port3 = IFID_IC[9:5];
    assign debug_port4 = reg1_data;
    assign debug_port5 = reg2_addr;
    assign debug_port6 = reg2_data;
    assign debug_port7 = PCSrc;
    // assign debug_port1 = 0; 
    // assign debug_port2 = 0;
    // assign debug_port3 = 0;
    // assign debug_port4 = 0;
    // assign debug_port5 = 0;
    // assign debug_port6 = 0;
    // assign debug_port7 = 0;
endmodule

/*
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

    // set up the clk 
    parameter clk_PERIOD=100;
    initial begin
        clk = 0;
        forever #(clk_PERIOD/2) clk <= ~clk;
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
*/