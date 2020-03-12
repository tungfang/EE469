module IC
(
  input [63:0] PC_in,
  output reg [31:0] instruction_out
);

  reg [8:0] Data[63:0];

  initial begin
    // LDUR x0, [x2, #3]
    Data[0] = 8'hf8; Data[1] = 8'h40; Data[2] = 8'h30; Data[3] = 8'h40;

    // ADD x9, x0, x5
    Data[4] = 8'h8b; Data[5] = 8'h05; Data[6] = 8'h00; Data[7] = 8'h09;

    // ORR x10, x1, x9
    Data[8] = 8'haa; Data[9] = 8'h09; Data[10] = 8'h00; Data[11] = 8'h2a;

    // AND x11, x9, x0
    Data[12] = 8'h8a; Data[13] = 8'h00; Data[14] = 8'h01; Data[15] = 8'h2b;

    // SUB x12 x0 x11
    Data[16] = 8'hcb; Data[17] = 8'h0b; Data[18] = 8'h00; Data[19] = 8'h0c;

    // STUR x9, [x3, #6]
    Data[20] = 8'hf8; Data[21] = 8'h00; Data[22] = 8'h60; Data[23] = 8'h69;

    // STUR x10, [x4, #6]
    Data[24] = 8'hf8; Data[25] = 8'h00; Data[26] = 8'h60; Data[27] = 8'h8a;

    // STUR x11, [x5, #6]
    Data[28] = 8'hf8; Data[29] = 8'h00; Data[30] = 8'h60; Data[31] = 8'hab;

    // STUR x12, [x6, #6]
    Data[32] = 8'hf8; Data[33] = 8'h00; Data[34] = 8'h60; Data[35] = 8'hcc;

    // B #10
    Data[36] = 8'h14; Data[37] = 8'h00; Data[38] = 8'h00; Data[39] = 8'h0a;
  end

  always @(PC_in) begin
    instruction_out[8:0] = Data[PC_in + 3];
    instruction_out[16:8] = Data[PC_in + 2];
    instruction_out[24:16] = Data[PC_in + 1];
    instruction_out[31:24] = Data[PC_in];
  end
endmodule
