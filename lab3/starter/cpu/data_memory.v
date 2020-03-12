module data_memory(
    input [31:0] inputAddress,
    input [31:0] inputData,
    input CONTROL_MemWrite,
    input CONTROL_MemRead,
    output reg [31:0] outputData
);
    reg [31:0] Data[31:0];
	integer initCount;

	initial begin
		for (initCount = 0; initCount < 32; initCount = initCount + 1) begin
			Data[initCount] = initCount * 5;
		end
	end
	always @(*) begin
		if (CONTROL_MemWrite == 1'b1) begin
        Data[inputAddress] = inputData;
      end else if (CONTROL_MemRead == 1'b1) begin
        outputData = Data[inputAddress];
      end else begin
        outputData = 32'hxxxxxxxx;
      end

      // Debug use only
        for (initCount = 0; initCount < 32; initCount = initCount + 1) begin
            // $display("RAM[%0d] = %0d", initCount, Data[initCount]);
        end

    end
endmodule


