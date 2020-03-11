module registers
(
    input clk,
    input [4:0] read1,
    input [4:0] read2,
    input [4:0] writeReg,
    input [63:0] writeData,
    input CONTROL_REGWRITE,
    output reg [63:0] data1,
    output reg [63:0] data2
);
    reg [31:0] Data[31:0];
    integer initCount;

    initial begin
        for (initCount = 0; initCount < 31; initCount = initCount + 1) begin
        Data[initCount] = initCount;
        end

        Data[31] = 31'h0;
    end

    always @(posedge clk) begin
        if (CONTROL_REGWRITE == 1'b1) begin
            Data[writeReg] = writeData;
        end

        data1 = Data[read1];
        data2 = Data[read2];

        // Debug use only
        for (initCount = 0; initCount < 32; initCount = initCount + 1) begin
            $display("REGISTER[%0d] = %0d", initCount, Data[initCount]);
        end
    end
endmodule

module register_testbench();
    reg clk;
    reg [4:0] read1;
    reg [4:0] read2;
    reg [4:0] writeReg;
    reg [63:0] writeData;
    reg CONTROL_REGWRITE;
    wire [63:0] data1;
    wire [63:0] data2;

    registers dut(clk, read1, read2, writeReg, writeData, CONTROL_REGWRITE, data1, data2);

    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        read1 = 0; read2 = 4; writeReg = 3; writeData = 15; CONTROL_REGWRITE = 0; @(posedge clk);
        CONTROL_REGWRITE = 1; @(posedge clk); @(posedge clk);
        read1 = 8; read2 = 24; writeReg = 12; writeData = 0; CONTROL_REGWRITE = 0; @(posedge clk);
        CONTROL_REGWRITE = 1; @(posedge clk); @(posedge clk); @(posedge clk);
    $stop;
    end
endmodule