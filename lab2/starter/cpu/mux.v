module mux2_1#(parameter width = 5)(din0, din1, sel, mux_out);
    input [width - 1:0] din0, din1;
    input sel;
    output reg [width - 1:0] mux_out;

    always @(*) begin
        mux_out = (sel) ? din1 : din0;
    end
    // assign mux_out = (sel) ? din1 : din0;
endmodule
