module WB_Mux
(
  input [63:0] input1,
  input [63:0] input2,
  input mem2reg_control,
  output reg [63:0] out
);
  always @(*) begin
    if (mem2reg_control == 0) begin
      out <= input1;
    end

    else begin
      out <= input2;
    end
  end
endmodule


module WB_Mux_testbench();
    reg clk;
    reg [31:0] input1;
    reg [31:0] input2;
    reg mem2reg_control;
    wire [31:0] out;

    WB_Mux dut(input1, input2, mem2reg_control, out);

    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        input1 = 8; input2 = 24; mem2reg_control = 0; @(posedge clk);
        @(posedge clk); @(posedge clk);
        input1 = 8; input2 = 24; mem2reg_control = 1; @(posedge clk);
        @(posedge clk); @(posedge clk);
    $stop;
    end
endmodule