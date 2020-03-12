module ARM_Control
(
  input [10:0] instruction,
  output reg [1:0] control_aluop,
  output reg control_alusrc,
  output reg control_isZeroBranch,
  output reg control_isUnconBranch,
  output reg control_memRead,
  output reg control_memwrite,
  output reg control_regwrite,
  output reg control_mem2reg
);

  always @(instruction) begin
    if (instruction[10:5] == 6'b000101) begin // B
      control_mem2reg <= 1'bx;
      control_memRead <= 1'b0;
      control_memwrite <= 1'b0;
      control_alusrc <= 1'b0;
      control_aluop <= 2'b01;
      control_isZeroBranch <= 1'b0;
      control_isUnconBranch <= 1'b1;
      control_regwrite <= 1'b0;

    end else if (instruction[10:3] == 8'b10110100) begin // CBZ
      control_mem2reg <= 1'bx;
      control_memRead <= 1'b0;
      control_memwrite <= 1'b0;
      control_alusrc <= 1'b0;
      control_aluop <= 2'b01;
      control_isZeroBranch <= 1'b1;
      control_isUnconBranch <= 1'b0;
      control_regwrite <= 1'b0;

    end else begin // R-Type Instructions
      control_isZeroBranch <= 1'b0;
      control_isUnconBranch <= 1'b0;

      case (instruction[10:0])
        11'b11111000010 : begin // LDUR
          control_mem2reg <= 1'b1;
          control_memRead <= 1'b1;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b1;
          control_aluop <= 2'b00;
          control_regwrite <= 1'b1;
        end

        11'b11111000000 : begin // STUR
          control_mem2reg <= 1'bx;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b1;
          control_alusrc <= 1'b1;
          control_aluop <= 2'b00;
          control_regwrite <= 1'b0;
        end

        11'b10001011000 : begin // ADD
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end

        11'b11001011000 : begin // SUB
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end

        11'b10001010000 : begin // AND
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end

        11'b10101010000 : begin // ORR
          control_mem2reg <= 1'b0;
          control_memRead <= 1'b0;
          control_memwrite <= 1'b0;
          control_alusrc <= 1'b0;
          control_aluop <= 2'b10;
          control_regwrite <= 1'b1;
        end

        default : begin // NOP
          control_isZeroBranch <= 1'bx;
      	 control_isUnconBranch <= 1'bx;
          control_mem2reg <= 1'bx;
          control_memRead <= 1'bx;
          control_memwrite <= 1'bx;
          control_alusrc <= 1'bx;
          control_aluop <= 2'bxx;
          control_regwrite <= 1'bx;
        end
      endcase
    end
  end
endmodule

/*
module ARM_Control_testbench();
    reg clk;
    reg [10:0] instruction;
    wire [1:0] control_aluop;
    wire control_alusrc;
    wire control_isZeroBranch;
    wire control_isUnconBranch;
    wire control_memRead;
    wire control_memwrite;
    wire control_regwrite;
    wire control_mem2reg;

    ARM_Control dut(instruction, control_aluop, control_alusrc, control_isZeroBranch,control_isUnconBranch, control_memRead, control_memwrite, control_regwrite, control_mem2reg);

    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        instruction <= 11'b10001010000; @(posedge clk); // R-format
        @(posedge clk); @(posedge clk); @(posedge clk);
        instruction <= 11'b11111000010; @(posedge clk); // LDUR
        @(posedge clk); @(posedge clk); @(posedge clk);
        instruction <= 11'b11111000000; @(posedge clk); // STUR
        @(posedge clk); @(posedge clk); @(posedge clk);
        instruction <= 11'b10110100000; @(posedge clk); // CBZ
        @(posedge clk); @(posedge clk); @(posedge clk);
        
    $stop;
    end

endmodule
*/