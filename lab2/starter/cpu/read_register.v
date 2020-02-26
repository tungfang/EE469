// Charles Tung Fang, Parsons Choi
// 2020/2/12
// EE 469 Lab 2
// reading from the instruction to determine which register to process

module read_register(read_enable, write_enable, read_register1, read_register2, write_register, write_data, reg_write, read_data1, read_data2);
    input read_enable, write_enable;
    input [4:0] read_register1, read_register2, write_register;
    input reg_write;
    input [31:0] write_data;
    output reg [31:0] read_data1, read_data2;
    
    reg [31:0] reg_file [0:31];
    
    integer i;
    // read txt file and store 32 registers to register file
    initial begin
        for (i = 0 ; i < 32; i = i + 1) begin
            reg_file[i] = i;
        end
        // $readmemb("C:/Users/ctung/Documents/UW/Winter2020/EE469/lab2/created_txt/reg_file.txt", reg_file);
    end

    always @(*) begin
        if (write_enable) begin
            if (write_enable && reg_write) begin
                reg_file[write_register] = write_data;
            //     // $display("reg_file[write_data]: %b ", reg_file[write_register]);
            end
        end
        if (read_enable) begin
            read_data1 = reg_file[read_register1];
            read_data2 = reg_file[read_register2]; 
            // $display("r2 addres: %b", read_register2);
           
            // $display("read_data2: %b", read_data2);
        end
        // $display("reg_file[10]: %b ", reg_file[10]);
        // $display("reg_file[11]: %b ", reg_file[11]);
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

