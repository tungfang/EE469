module cpsr_register(Branch, instruction, Zero, read_data1, PCSrc);
    input logic Branch, Zero;
    input logic [5:0] instruction;
    input logic [31:0] read_data1;
    output logic PCSrc;

    // decides which condition code to use
    always_comb begin
        if (Branch) begin
            case(instruction)
                6'b000100:          // BEQ
                begin
                    PCSrc = Zero;
                end
                6'b000101:          // BNE
                begin
                    PCSrc = ~Zero;
                end
                6'b000111:          // BGTZ
                begin
                    if(read_data1 > 0) 
                        PCSrc = 1;
                    else
                        PCSrc = 0;
                end
                6'b000110;          // BLEZ
                begin
                    if(read_data1 <= 0)
                        PCSrc = 1;
                    else
                        PCSrc = 0;
                end
                
                default: PCSrc = 0;
            endcase
        end
    end