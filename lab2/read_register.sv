// Charles Tung Fang, Parsons Choi
// 2020/2/12
// EE 469 Lab 2
// reading from the instruction to determine which register to process

module read_register(clk, reg_file, read_register1, read_register2, write_register, write_data, reg_write, read_data1, read_data2);
    input logic clk;
    input logic [31:0] reg_file [0:31];
    input logic [4:0] read_register1, read_register2, write_register;
    input logic reg_write;
    input logic [31:0] write_data;
    output logic [31:0] read_data1, read_data2;


    assign read_data1 = reg_file[read_register1];
    assign read_data2 = reg_file[read_register2];
    
    always_comb begin
        if (reg_write) begin
            reg_file[write_register] = write_data;
            $display("reg_file[write_data]: %b ", reg_file[write_register]);
        end
    end 
endmodule

module read_register_testbench();
    logic clk;
    logic [31:0] reg_file [0:31];
    logic [4:0] read_register1, read_register2, write_register;
    logic reg_write;
    logic [31:0] write_data, read_data1, read_data2;

    read_register dut(clk, reg_file, read_register1, read_register2, write_register, write_data, reg_write, read_data1, read_data2);

    // Set up the clock
    parameter CLOCK_PERIOD=100;
        initial begin
            clk <= 0;
            forever #(CLOCK_PERIOD/2) clk <= ~clk;
        end

    initial begin
        read_register1 <= 0; read_register2 <= 1; write_register <= 3; reg_write <= 0; write_data <= 12;       @(posedge clk);
        @(posedge clk);
        write_register <= 3; reg_write <= 1; write_data <= 12;       @(posedge clk);
        @(posedge clk);
        // read_register1 <= 0; read_register2 <= 1; write_register <= 3; reg_write <= 0; write_data <= 12;       @(posedge clk);
        @(posedge clk);
    $stop;
    end
endmodule

