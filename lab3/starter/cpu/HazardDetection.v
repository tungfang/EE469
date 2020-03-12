module HazardDetection
(
	input Ex_memRead,
	input [4:0] EX_write_reg,
	input [63:0] ID_PC,
	input [31:0] ID_IC,
	output reg IFID_write,
	output reg PC_Write,
	output reg Ctrl_mux
);
	always @(*) begin
		if (Ex_memRead == 1'b1 && ((EX_write_reg === ID_IC[9:5]) || (EX_write_reg === ID_IC[20:16]))) begin
			IFID_write <= 1'b1;
			PC_Write <= 1'b1;
			Ctrl_mux <= 1'b1;

		end else begin
			IFID_write <= 1'b0;
			PC_Write <= 1'b0;
			Ctrl_mux <= 1'b0;
		end

	end
endmodule

/*
module HazardDetection_testbench();
    reg clk;
    reg EX_memRead;
    reg [4:0] EX_write_reg;
    reg [31:0] ID_PC, ID_IC;
    wire IFID_write, PC_write, control_mux;

    HazardDetection dut(EX_memRead, EX_write_reg, ID_PC, ID_IC, IFID_write, PC_write, control_mux);

    // set up the clock 
    parameter CLOCK_PERIOD=100;
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end


    initial begin
        EX_memRead = 0; @(posedge clk);
        EX_memRead = 1; EX_write_reg = 16; ID_IC[9:5] = 16; @(posedge clk); 
        EX_memRead = 0; @(posedge clk);
        EX_memRead = 1; EX_write_reg = 12; ID_IC[20:16] = 12; @(posedge clk); 
        
    $stop;
    end
    
endmodule
*/