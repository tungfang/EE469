module alu #(parameter DATA_WIDTH = 32)(
    input [31:0] bus_a,
    input [31:0] bus_b,
    input [2:0] alu_ctrl,
    output reg [31:0] out,
    output reg zero, overflow, carryout, negative
    );
    
    reg [31:0] alu_mem;

    always @(*) begin
        
        if (alu_ctrl == 3'b010) begin   // ALU_ADD
            alu_mem = bus_a + bus_b;
        end
        else if (alu_ctrl == 3'b110) begin      // ALU_SUB
            alu_mem = bus_a - bus_b;
        end
        else alu_mem = 0;

        case(alu_ctrl)
            3'b000:     // ALU_AND
            begin
                alu_mem = bus_a & bus_b;
                carryout = 0;
                overflow = 0;
            end
            3'b001:     // ALU_OR
            begin
                alu_mem = bus_a | bus_b;
                carryout = 0;
                overflow = 0;
            end
            3'b010:     // ALU_ADD
            begin
                out = alu_mem[DATA_WIDTH - 1:0];
			    overflow = alu_mem[DATA_WIDTH] ^ alu_mem[DATA_WIDTH - 1];
			    carryout = alu_mem[DATA_WIDTH];
            end
            3'b110:     //ALU_SUB
            begin
                out = alu_mem[DATA_WIDTH - 1:0];
			    overflow = alu_mem[DATA_WIDTH] ^ alu_mem[DATA_WIDTH - 1];
			    carryout = alu_mem[DATA_WIDTH];
            end
            default:
            begin
                out = 0;
                carryout = 0;
                overflow = 0;
            end
        endcase 

        negative = out[DATA_WIDTH-1];   // most significant bit for sign
        zero = out == 0;
        // $display("ALU Result: %b", out);
    end

endmodule 
