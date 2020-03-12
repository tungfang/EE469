module HazardDetection
(
	input EX_memRead_in,
	input [4:0] EX_write_reg,
	input [31:0] ID_PC,
	input [31:0] ID_IC,
	output reg IFID_write_out,
	output reg PC_Write_out,
	output reg Control_mux_out
);
	always @(*) begin
        $display("Hazard Detection Entered. EX_memRead_in = %b", EX_memRead_in);
		if (EX_memRead_in == 1'b1 && ((EX_write_reg === ID_IC[9:5]) || (EX_write_reg === ID_IC[20:16]))) begin
			IFID_write_out <= 1'b1;
			PC_Write_out <= 1'b1;
			Control_mux_out <= 1'b1;

		end else begin
			IFID_write_out <= 1'b0;
			PC_Write_out <= 1'b0;
			Control_mux_out <= 1'b0;
		end

	end
endmodule


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