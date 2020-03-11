module SignExtender(input [31:0] instruction, output reg [63:0] extended_instruction);
    always@(instruction) begin
        // Branch
        if(instruction[31:26] == 6'b000101) begin
            extended_instruction[25:0] = instruction[25:0];
	    extended_instruction[31:26] = {32{instruction[25]}};
        end 
        // CBZ
        else if (instruction[31:24] == 8'b10110100) begin
            extended_instruction[19:0] = instruction[23:5];
	    extended_instruction[31:20] = {32{instruction[23]}};
        end 
        // D Type
        else begin 
            extended_instruction[9:0] = instruction[20:12];
	    extended_instruction[31:10] = {32{instruction[20]}};
        end
    end
endmodule