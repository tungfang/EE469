module control(instruction, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    input [5:0] instruction;
    output reg RegDst, Branch, MemRead, MemtoReg,  MemWrite, ALUSrc, RegWrite;
    output reg [1:0] ALUOp;

    reg R_format, lw, sw, beq;

    // checkouk which type is the instruction
    always @(*) begin
        if (instruction == 6'b000000) begin
            R_format = 1;
            lw = 0;
            sw = 0;
            beq = 0;
        end else if (instruction == 6'b100011) begin
            R_format = 0;
            lw = 1;
            sw = 0;
            beq = 0;
        end else if (instruction == 6'b101011) begin
            R_format = 0;
            lw = 0;
            sw = 1;
            beq = 0;
        end else if (instruction == 6'b000101) begin	//BNE
            R_format = 0;
            lw = 0;
            sw = 0;
            beq = 1;
		end else if (instruction == 6'b000100) begin	// BEQ
            R_format = 0;
            lw = 0;
            sw = 0;
            beq = 1;
		end else if (instruction == 6'b000110) begin	// BLEZ
            R_format = 0;
            lw = 0;
            sw = 0;
            beq = 1;
		end else if (instruction == 6'b000111) begin	// BGTZ
            R_format = 0;
            lw = 0;
            sw = 0;
            beq = 1;
        end else begin
            R_format = 0;
            lw = 0;
            sw = 0;
            beq = 0;
        end
    end

    // Change the output based on the type of instruction
    always @(*) begin
        if (R_format) begin
            RegDst = 1;
            ALUSrc = 0;
            MemtoReg = 0;
            RegWrite = 1;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp[0] = 0;
            ALUOp[1] = 1;
        end else if (lw) begin
            RegDst = 0;
            ALUSrc = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead = 1;
            MemWrite = 0;
            Branch = 0;
            ALUOp[0] = 0;
            ALUOp[1] = 0;
        end else if (sw) begin 
            RegDst = 0;
            ALUSrc = 1;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 1;
            Branch = 0;
            ALUOp[0] = 0;
            ALUOp[1] = 0;
        end else if (beq) begin
            RegDst = 0;
            ALUSrc = 0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 1;
            ALUOp[0] = 1;
            ALUOp[1] = 0;
        end else begin 
            RegDst = 0;
            ALUSrc = 0;
            MemtoReg = 0;
            RegWrite = 0;
            MemRead = 0;
            MemWrite = 0;
            Branch = 0;
            ALUOp[0] = 0;
            ALUOp[1] = 0;
        end
    end
        
endmodule

// module control_testbench();
//     reg clk;
//     reg [5:0] instruction;
//     reg RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
//     reg [1:0] ALUOp;    

//     control dut(instruction, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

//     // Set up the clock
//     parameter CLOCK_PERIOD=100;
//         initial begin
//             clk <= 0;
//             forever #(CLOCK_PERIOD/2) clk <= ~clk;
//         end

//     initial begin
//         instruction <= 6'b000000;      @(posedge clk);
//                                     @(posedge clk);
//         instruction <= 6'b100011;      @(posedge clk);
//                                     @(posedge clk);
//         instruction <= 6'b101011;      @(posedge clk);
//                                     @(posedge clk);
//         instruction <= 6'b000100;      @(posedge clk);
//                                     @(posedge clk); 
//     $stop;
//     end
// endmodule