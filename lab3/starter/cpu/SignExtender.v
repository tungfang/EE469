module SignExtender(input [31:0] instruction, output reg [63:0] extended_instruction);
    always@(instruction) begin
        // Branch
        if(instruction[31:26] == 6'b000101) begin
            extended_instruction = {64{instruction[25]}, instruction};
        end 
        // CBZ
        else if (instruction[31:24] == 8'b10110100) begin
            extended_instruction[63:20] = {64{instruction[23]}, instruction[23:5]};

        end 
        // D Type
        else begin 
            extended_instruction[63:10] = {64{instruction[20]}, instruction[20:12]};
        end
    end