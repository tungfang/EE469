module mux2_1#(parameter width = 5)(din0, din1, sel, mux_out);
    input logic [width - 1:0] din0, din1;
    input logic sel;
    output logic [width - 1:0] mux_out;

    assign mux_out = (sel) ? din1 : din0;
endmodule
