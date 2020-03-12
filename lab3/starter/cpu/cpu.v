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
    wire[31:0] IC;

    // Instruction Memory
    IC mem1 (PC, IC);

    wire[63:0] mem_address_out;
    reg[63:0] mem_data_in;
    wire control_memwrite_out;
    wire control_memread_out;
    wire[63:0] mem_data_out;

    // Data Memory
    Data_Memory mem2 (mem_address_out, mem_data_in, control_memwrite_out, control_memread_out, mem_data_out);

  	wire Hazard_PCWrite;
	  wire Hazard_IFIDWrite;

    /* Stage : Instruction Fetch */
    wire PCSrc_wire;
    wire [63:0] jump_PC_wire;
    wire [63:0] IFID_PC;
    wire [31:0] IFID_IC;
    IFID cache1 (clk, PC, IC, Hazard_IFIDWrite, IFID_PC, IFID_IC);


	always @(posedge clk) begin
		if (Hazard_PCWrite !== 1'b1) begin
			 if (PC === 64'bx) begin
				PC <= 0;
			 end else if (PCSrc_wire == 1'b1) begin
				PC <= jump_PC_wire;
			 end else begin
				PC <= PC + 4;
		end
	 end
	end

  /* Stage : Instruction Decode */
  wire IDEX_memRead;
  wire [4:0] IDEX_write_reg;
  wire Control_mux_wire;
  HazardDetection moda (IDEX_memRead, IDEX_write_reg, IFID_PC, IFID_IC, Hazard_IFIDWrite, Hazard_PCWrite, Control_mux_wire);

  wire [1:0] CONTROL_aluop; // EX
  wire CONTROL_alusrc; // EX
  wire CONTROL_isZeroBranch; // M
  wire CONTROL_isUnconBranch; // M
  wire CONTROL_memRead; // M
  wire CONTROL_memwrite; // M
  wire CONTROL_regwrite; // WB
  wire CONTROL_mem2reg; // WB
  ARM_Control unit1 (IFID_IC[31:21], CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg);

  wire [1:0] CONTROL_aluop_wire; // EX
  wire CONTROL_alusrc_wire; // EX
  wire CONTROL_isZeroBranch_wire; // M
  wire CONTROL_isUnconBranch_wire; // M
  wire CONTROL_memRead_wire; // M
  wire CONTROL_memwrite_wire; // M
  wire CONTROL_regwrite_wire; // WB
  wire CONTROL_mem2reg_wire; // WB
  Control_Mux maaa (CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg, Control_mux_wire, CONTROL_aluop_wire, CONTROL_alusrc_wire, CONTROL_isZeroBranch_wire, CONTROL_isUnconBranch_wire, CONTROL_memRead_wire, CONTROL_memwrite_wire, CONTROL_regwrite_wire, CONTROL_mem2reg_wire);

  wire [4:0] reg2_wire;
  ID_Mux unit2(IFID_IC[20:16], IFID_IC[4:0], IFID_IC[28], reg2_wire);

  wire [63:0] reg1_data, reg2_data;
  wire MEMWB_regwrite;
  wire [4:0] MEMWB_write_reg;
  wire [63:0] write_reg_data;
  Registers unit3(clk, IFID_IC[9:5], reg2_wire, MEMWB_write_reg, write_reg_data, MEMWB_regwrite, reg1_data, reg2_data);

  wire [63:0] sign_extend_wire;
  SignExtend unit4 (IFID_IC, sign_extend_wire);

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
  wire [63:0] IDEX_sign_extend;
  wire [10:0] IDEX_alu_control;
  wire [4:0] IDEX_forward_reg1;
  wire [4:0] IDEX_forward_reg2;
  IDEX cache2 (clk, CONTROL_aluop_wire, CONTROL_alusrc_wire, CONTROL_isZeroBranch_wire, CONTROL_isUnconBranch_wire, CONTROL_memRead_wire, CONTROL_memwrite_wire, CONTROL_regwrite_wire, CONTROL_mem2reg_wire, IFID_PC, reg1_data, reg2_data, sign_extend_wire, IFID_IC[31:21], IFID_IC[4:0], IFID_IC[9:5], reg2_wire, IDEX_aluop, IDEX_alusrc, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, IDEX_PC, IDEX_reg1_data, IDEX_reg2_data, IDEX_sign_extend, IDEX_alu_control, IDEX_write_reg, IDEX_forward_reg1, IDEX_forward_reg2);


  /* Stage : Execute */
  wire [63:0] shift_left_wire;
  wire [63:0] PC_jump;
  wire jump_is_zero;
  Shift_Left unit5 (IDEX_sign_extend, shift_left_wire);
  ALU unit6 (IDEX_PC, shift_left_wire, 4'b0010, PC_jump, jump_is_zero);

  wire [4:0] EXMEM_write_reg;
  wire EXMEM_regwrite;
  wire EXMEM_mem2reg;
  wire [1:0] Forward_A;
  wire [1:0] Forward_B;
  ForwardingUnit modd (IDEX_forward_reg1, IDEX_forward_reg2, EXMEM_write_reg, MEMWB_write_reg, EXMEM_regwrite, MEMWB_regwrite, Forward_A, Forward_B);

  wire [63:0] alu_1_wire;
  Forward_ALU_Mux lal1 (IDEX_reg1_data, write_reg_data, mem_address_out, Forward_A, alu_1_wire);

  wire [63:0] alu_2_wire;
  Forward_ALU_Mux lal2 (IDEX_reg2_data, write_reg_data, mem_address_out, Forward_B, alu_2_wire);

  wire [3:0] alu_main_control_wire;
  ALU_Control unit7(IDEX_aluop, IDEX_alu_control, alu_main_control_wire);

  wire [63:0] alu_data2_wire;
  ALU_Mux mux3(alu_2_wire, IDEX_sign_extend, IDEX_alusrc, alu_data2_wire);

  wire alu_main_is_zero;
  wire [63:0] alu_main_result;
  ALU main_alu(alu_1_wire, alu_data2_wire, alu_main_control_wire, alu_main_result, alu_main_is_zero);

  wire EXMEM_isZeroBranch;
  wire EXMEM_isUnconBranch;
  wire EXMEM_alu_zero;
  EXMEM cache3(clk, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, PC_jump, alu_main_is_zero, alu_main_result, IDEX_reg2_data, IDEX_write_reg, EXMEM_isZeroBranch, EXMEM_isUnconBranch, control_memread_out, control_memwrite_out, EXMEM_regwrite, EXMEM_mem2reg, jump_PC_wire, EXMEM_alu_zero, mem_address_out, mem_data_out, EXMEM_write_reg);


  /* Stage : Memory */
  Branch unit8 (EXMEM_isUnconBranch, EXMEM_isZeroBranch, EXMEM_alu_zero, PCSrc_wire);

  wire [63:0] MEMWB_address;
  wire [63:0] MEMWB_read_data;
  MEMWB cache4(clk, mem_address_out, mem_data_in, EXMEM_write_reg, EXMEM_regwrite, EXMEM_mem2reg, MEMWB_address, MEMWB_read_data, MEMWB_write_reg, MEMWB_regwrite, MEMWB_mem2reg);


  /* Stage : Writeback */
  WB_Mux unit9 (MEMWB_address, MEMWB_read_data, MEMWB_mem2reg, write_reg_data);

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