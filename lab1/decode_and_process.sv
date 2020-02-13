// Charles Tung Fang
// 2020/1/26
// EE 469 Lab 1
// decode and process read the instruction code and modify the value in the register files

module decode_and_process(clk, inst, CPSR_flag);
    input logic clk;
    input logic [31:0] inst;
    output logic [31:0] CPSR_flag;
    logic [31:0] register_file [0:63];

    logic [31:0] CPSR;
    logic [3:0] cond;
    logic [3:0] OpCode;
    logic [3:0] Rn;
    logic [3:0] Rd; 
    logic [3:0] Rm;
    logic [11:0] operand2; 
    logic [1:0] category;
    logic immediate_op;
    

    assign cond = inst[31:28];
    assign OpCode = inst[24:21]; // Operation Code
    assign Rn = inst[19:16]; // 1st Operand Reg
    assign Rd = inst[15:12]; // Destination Reg
    assign Rm = inst[3:0];
    assign immediate_op = inst[25];
    assign operand2 = inst[11:0]; // for data processing
    assign category = inst[27:26];


    enum{EOR, SUB, ADD, TST, TEQ, CMP, ORR, MOV, BIC, MVN, LDR, B, BL} ps, ns;

    
    logic [31:0] first_reg;
    logic [31:0] second_reg;
    logic [31:0] temp;
    
    always_ff @(posedge clk) begin
        ps <= ns;
        if (category == 2'b00)
        begin
        $write("Next Operation: %s    %b  ", ns, OpCode);
        $write("Rn: %b    Rm: %b    Rd: %b    ", Rn, Rm, Rd);                                               
        $write("Reg[Rn]: %b, Reg[Rm]: %b, Reg[Rd]: %b                                                   "
        , register_file[Rn], register_file[Rm], register_file[Rd]);
        end else if (category == 2'b01)
        begin
        $write("Next Operation: LDR                                              ");
        end else if (category == 2'b10)
        begin                                
        $write("Next Operation: Branch                                           ");
        end
        register_file[Rd] <= temp;
        CPSR_flag <= CPSR;
    end

    integer i;

    initial begin
      // read txt file and store inst to code memory
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab1/memArray.txt", register_file);
    end
    
    logic [31:0] test_reg;
    assign test_reg = register_file[Rd];
    // testing EOR, ORR
    // assign register_file[15] = 32'b11111111111111111111111111111111;
    // assign register_file[8] = 32'b00000000000000000000000000000001;
    
    // testing ADD, SUB
    // assign register_file[0] = 32'b00000000000000000000000000000001;
    // assign register_file[1] = 32'b00000000000000000000000000000001; 

    always_comb begin
        
        
        // if (OpCode == 4'b0001) ns = EOR;
        // else ns = ADD;
        if (category == 2'b00) begin // Data Processing
            if (OpCode == 4'b0001) ns = EOR;
            else if (OpCode == 4'b0010) ns = SUB;
            else if (OpCode == 4'b0100) ns = ADD;
            else if (OpCode == 4'b1000) ns = TST;
            else if (OpCode == 4'b1001) ns = TEQ;
            else if (OpCode == 4'b1010) ns = CMP;
            else if (OpCode == 4'b1100) ns = ORR;
            else if (OpCode == 4'b1101) ns = MOV;
            else if (OpCode == 4'b1110) ns = BIC;
            else if (OpCode == 4'b1111) ns = MVN;
        end else if (category == 2'b01) begin// Single Data Transfer
            ns = LDR;
        end else if (category == 2'b10) begin
            if (inst[24] == 0) ns = B;
            else ns = BL;
        end
        
        case (ps)
            // XOR
            EOR: 
            begin
                first_reg = register_file[Rn];
                second_reg = register_file[Rm];
                for (i = 0; i < 31; i = i + 1) begin 
                    temp[i] = first_reg[i] ^ second_reg[i];
                end
            end
            SUB: if (immediate_op == 0) temp = register_file[Rn] - register_file[Rm];
                 else temp = register_file[Rn] - operand2[7:0];
            ADD: if (immediate_op == 0) temp = register_file[Rn] + register_file[Rm];
                 else temp = register_file[Rn] + operand2[7:0];
                 
            TST: // set condition codes on Op1 AND Op2
            begin
                first_reg = register_file[Rn];
                second_reg = register_file[Rm];
                
                CPSR[21] = first_reg[31] & second_reg[31];
            end
            TEQ: // set condition codes on Op1 EOR Op2
            begin
                first_reg = register_file[Rn];
                second_reg = register_file[Rm];
                
                CPSR[21] = first_reg[31] ^ second_reg[31];
            end
            CMP: 
            begin 
                first_reg = register_file[Rn];
                second_reg = register_file[Rm];
                CPSR[21] = first_reg[31] - second_reg[31];
            end
            ORR:
            begin
                first_reg = register_file[Rn];
                second_reg = register_file[Rm];
                for (i = 0; i < 31; i = i + 1) begin 
                    temp[i] = first_reg[i] | second_reg[i];
                end
            end
            MOV:
            begin
                second_reg = register_file[Rm];
                CPSR[21] = second_reg[31];
            end
            BIC: 
            begin
                first_reg = register_file[Rn];
                second_reg = register_file[Rm];

                CPSR[21] = first_reg[31] & (~second_reg[31]);
            end
            MVN:
            begin
                second_reg = register_file[Rm];
                CPSR[21] = ~second_reg[31];
            end
            LDR: temp = register_file[Rn];
            B: temp = temp;
            BL: temp = temp;
        endcase
    end
    
endmodule


module decode_and_process_testbench();
    logic [31:0] inst;
    logic [31:0] register_file [0:63];
    logic clk;
    logic [31:0] CPSR_flag;

    decode_and_process dut(clk, inst, CPSR_flag);
    
    // Set up the clock
    parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

    initial begin
        // ADD
        inst <= 32'b11100000100000000010000000000001;    @(posedge clk);
        @(posedge clk);@(posedge clk);
        // ORR
        inst <= 32'b11100001100011110011000000001000;    @(posedge clk);
        @(posedge clk);@(posedge clk);
        // TST
        inst <= 32'b11100001000111110011000000001000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // TEQ
        inst <= 32'b11100001001111110011000000001000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // CMP
        inst <= 32'b11100001010111110011000000001000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // MOV
        inst <= 32'b11100001101111110011000000001000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // BIC
        inst <= 32'b11100001110111110011000000001000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // MVN
        inst <= 32'b11100001111111110011000000001000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // LDR
        inst <= 32'b11100100110100000001000000000000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // B
        inst <= 32'b11101010000000000000000000100000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
        // BL
        inst <= 32'b11101011000000000000000001000000;   @(posedge clk);
        @(posedge clk);@(posedge clk);
    $stop;
    end

endmodule

