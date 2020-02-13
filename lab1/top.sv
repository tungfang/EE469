module top(clk, LED, USBPU);
    input logic clk;    // 16MHz clock
    output logic LED;   // User/boot LED next to power LED
    output logic USBPU; // USB pull-up resistor
    logic [31:0] register_file [0:63];
    logic [31:0] PC = 0;
    logic [31:0] inst;
    logic [3:0] operation_code;
    logic [23:0] branch_offset;
    logic [31:0] CPSR_flag;
    //code memory
    logic [31:0] code_mem [0:12];
    // register file stores 32 registers with 64 bits per register
    
    // two states for PC. s0 is PC = PC + 4; s1 is PC = PC + branch value
    enum{s0, s1} ps, ns;

    initial begin
      // read txt file and store inst to code memory
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab1/code_mem.txt", code_mem);
    end

    initial begin
      // read txt file and store inst to reg mem
      $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab1/memArray.txt", register_file);
    end

    // decode and process the instruction on the register file
    decode_and_process action(.clk(clk), .inst(inst), .CPSR_flag(CPSR_flag));

    logic [31:0] temp;

    // update PC states and its value
    always_ff @(posedge clk) begin
        $write("PC value %d    ", PC);
        $display("Instruction: %b    ", inst);
        ps <= ns;
        if (ps == s0) PC <= PC + 4;
        else PC <= PC + branch_offset;
    end
    

    always_comb begin
      // temp = register_file[1];
      inst = code_mem[PC % 13];
      operation_code = inst[27:24];
      
      // Defaults
      ns = ps;
      case (ps)
        s0: if (operation_code == 4'b1010) begin // test if the operation is branch
              ns = s1;
              branch_offset = inst[23:0];
            end else ns = s0;
        s1: ns = s0;
      endcase      
    end

endmodule

module top_testbench();
  logic clk;
  logic LED;
  logic USBPU;
  integer i;
  logic [31:0] register_file [0:63];

  top dut (clk, LED, USBPU);

  // Set up the clock
  parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

  initial begin
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
  $stop;
  end

endmodule
