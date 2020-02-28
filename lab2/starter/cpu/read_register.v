// Charles Tung Fang, Parsons Choi
// 2020/2/12
// EE 469 Lab 2
// reading from the instruction to determine which register to process

module read_register(read_enable, write_enable, read_register1, read_register2, write_register, write_data, reg_write, read_data1, read_data2, start);
    input read_enable, write_enable, start;
    input [4:0] read_register1, read_register2, write_register;
    input reg_write;
    input [31:0] write_data;
    output reg [31:0] read_data1, read_data2;
    
    reg [31:0] reg_file [0:31];
    
    // integer i;
    // // read txt file and store 32 registers to register file
    initial begin
        reg_file[9] = 9;
        reg_file[1] = 1;
        reg_file[15] = 15;
        // for (i = 0 ; i < 32; i = i + 1) begin
        //     reg_file[i] = i;
        // end
        // $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/reg_file.txt", reg_file);
    end

    always @(*) begin
        if (write_enable) begin
            if (write_enable && reg_write) begin
                reg_file[write_register] = write_data;
            end
        end
        if (read_enable) begin
            read_data1 = reg_file[read_register1];
            read_data2 = reg_file[read_register2]; 
        end
    end 

    always @(start) begin
        reg_file[9] = 9;
        reg_file[1] = 1;
        reg_file[15] = 15;
    end
endmodule

// module read_register_testbench();
//     reg clk;
//     reg [31:0] reg_file [0:31];
//     reg [4:0] read_register1, read_register2, write_register;
//     reg reg_write;
//     reg [31:0] write_data, read_data1, read_data2;

//     read_register dut(reg_file, read_register1, read_register2, write_register, write_data, reg_write, read_data1, read_data2);

//     // Set up the clock
//     parameter CLOCK_PERIOD=100;
//         initial begin
//             clk <= 0;
//             forever #(CLOCK_PERIOD/2) clk <= ~clk;
//         end

//     initial begin
//         read_register1 <= 0; read_register2 <= 1; write_register <= 3; reg_write <= 0; write_data <= 12;       @(posedge clk);
//         @(posedge clk);
//         write_register <= 3; reg_write <= 1; write_data <= 12;       @(posedge clk);
//         @(posedge clk);
//         // read_register1 <= 0; read_register2 <= 1; write_register <= 3; reg_write <= 0; write_data <= 12;       @(posedge clk);
//         @(posedge clk);
//     $stop;
//     end
// endmodule

