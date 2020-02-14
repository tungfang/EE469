module control(instruction, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    input logic [5:0] instruction;
    output logic RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite;
    
    logic R_format, lw, sw, beq;

    
endmodule

module control_testbench();

endmodule