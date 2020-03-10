module instruction_memory(
    input [31:0] PC,
    output reg [31:0] instruction
);

    reg [31:0] instruction_mem [0:9];

    initial begin
        $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab3/created_txt/instruction_memory.txt", instruction_mem);
    end

    always @(*) begin
        instruction = instruction_mem[PC >> 2];
    end
endmodule

module instruction_memory_testbench();
    reg clk;
    reg [31:0] PC;
    wire [31:0] instruction;

    instruction_memory dut(PC, instruction);

    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end


    initial begin
        PC = 0; @(posedge clk);
        @(posedge clk); @(posedge clk);
        PC = 4; @(posedge clk);
        @(posedge clk); @(posedge clk); 
        PC = 8; @(posedge clk);
    $stop;
    end
    
endmodule

