module SignExtender(input [31:0] instruction, output reg [31:0] extended_instruction);
    always@(instruction) begin
        // Branch
        if(instruction[31:26] == 6'b000101) begin
            extended_instruction[25:0] = instruction;
	    extended_instruction[31:26] = {32{instruction[25]};
        end 
        // CBZ
        else if (instruction[31:24] == 8'b10110100) begin
            extended_instruction[31:20] = {64{instruction[23]}};
	    extended_instruction[19:0] = instruction[23:5];

        end 
        // D Type
        else begin 
            extended_instruction[31:10] = {64{instruction[20]}};
	    extended_instruction[9:0] = instruction [20:12];
        end
    end