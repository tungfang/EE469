module ALU_control(function_code, ALUOp, ALU_ctrl);
    input logic [5:0] function_code;
    input logic [1:0] ALUOp;
    output logic [2:0] ALU_ctrl;

    // Output desired ALU action based on input ALUOp and function code
    always_comb begin
        if (ALUOp == 2'b00) begin 
            // instruction operation: ldr/str word
            // desired ALU action: add
            ALU_ctrl = 3'b010;
            $display("add");
        end else if (ALUOp == 2'b01) begin 
            // instruction operation: branch eq
            // desired ALU action: subtract
            ALU_ctrl = 3'b110;
            $display("subtract");
        end else if (ALUOp == 2'b10) begin 
            // R-type
            if (function_code == 6'b100000) begin 
                // add
                ALU_ctrl = 3'b010;
                $display("add");
            end else if (function_code == 6'b100010) begin 
                // subtract
                ALU_ctrl = 3'b110;
                $display("subtract");
            end else if (function_code == 6'b100100) begin 
                // AND
                ALU_ctrl = 3'b000;
                $display("AND");
            end else if (function_code == 6'b100101) begin 
                // OR
                ALU_ctrl = 3'b001;
                $display("OR");
            end else if (function_code == 6'b101010) begin 
                // slt
                ALU_ctrl = 3'b111;
                $display("slt");
            end else begin 
                ALU_ctrl = 3'bxxx;
            end
        end
    end
endmodule

module ALU_control_testbench();
    logic clk;
    logic [5:0] function_code;
    logic [1:0] ALUOp;
    logic [2:0] ALU_ctrl; 

    ALU_control dut(function_code, ALUOp, ALU_ctrl);

    // Set up the clock
    parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

    initial begin
    ALUOp <= 2'b00; @(posedge clk);
    @(posedge clk);
    ALUOp <= 2'b01; @(posedge clk);
    @(posedge clk);
    ALUOp <= 2'b10; function_code <= 6'b100000; @(posedge clk);
    @(posedge clk);
    function_code <= 6'b100010; @(posedge clk);
    @(posedge clk);
    function_code <= 6'b100100; @(posedge clk);
    @(posedge clk);
    function_code <= 6'b100101; @(posedge clk);
    @(posedge clk);
    function_code <= 6'b101010; @(posedge clk);
    @(posedge clk);
  $stop;
  end
endmodule