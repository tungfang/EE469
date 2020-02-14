module alu #(parameter DATA_WIDTH = 32) (clk, bus_a, bus_b, alu_ctrl, out, zero, overflow, carryout, negative);

    `include "constants_32.sv"

    input logic clk;
    input logic [DATA_WIDTH-1:0] bus_a, bus_b;
    input logic [2:0] alu_ctrl;
    output logic [DATA_WIDTH-1:0] out;
    output logic zero, overflow, carryout, negative;

    logic [DATA_WIDIH:0] alu_mem;

    always_comb begin
        
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
                carryout = 1'bX;
                overflow = 1'bX;
            end
            3'b001:     // ALU_OR
            begin
                alu_mem = bus_a | bus_b;
                carryout = 1'bX;
                overflow = 1'bX;
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
                out = 'bX;
                carryout = 1'bX;
                overflow = 1'bX;
            end
        endcase 

        negative = out[DATA_WIDTH-1];   // most significant bit for sign
        zero = out == 0;
    end






endmodule 