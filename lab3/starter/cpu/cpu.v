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
  reg [31:0] IC;
  wire [31:0] jump_PC;
  wire [31:0] IFID_PC; // pipeline pc
  wire [31:0] IFID_IC; // pipeline instruction counter
  wire PCSrc;
  
  /* Hazard Logics */
  wire Hazard_PCWrite;
  wire Hazard_IFIDWrite;
  

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

  /* IF: Instruction Fetch */
  IFID cache1(clk, PC, IC);

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
  control_Mux ctrl_mux(CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg, Control_mux_wire, CONTROL_aluop_wire, CONTROL_alusrc_wire, CONTROL_isZeroBranch_wire, CONTROL_isUnconBranch_wire, CONTROL_memRead_wire, CONTROL_memwrite_wire, CONTROL_regwrite_wire, CONTROL_mem2reg_wire);

  wire [4:0] reg2_wire;
  ID_Mux decode_mux(IFID_IC[20:16], IFID_IC[4:0], IFID_IC[28], reg2_wire);

  wire [31:0] reg1_data, reg2_data;
  wire MEMWB_regwrite;
  wire [4:0] MEMWB_write_reg;
  wire [31:0] write_reg_data;
  registers reg_file(clk, IFID_IC[9:5], reg2_wire, MEMWB_write_reg, write_reg_data, MEMWB_regwrite, reg1_data, reg2_data);

  wire [31:0] sign_extend_wire;
  // SignExtend unit4 (IFID_IC, sign_extend_wire);


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
