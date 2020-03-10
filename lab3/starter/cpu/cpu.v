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
