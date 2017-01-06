module counter(
	//output
	output reg [31:0] qout,
	output tc, 
	//input
	input wire enable, 
	input wire load, 
	input wire [31:0]din,
	input wire reset,
	input wire clk
);
	
	parameter mod = 32'b0000_0000_0001_0111_1101_0111_1000_0011_1111;

	always @(posedge clk) begin
		if ( reset == 1) 
			qout <= 0;
		else if (load == 1)
			qout <= din;
		else if ( enable == 1) begin
			if (qout == mod) 
				qout <= 0;
			else 
				qout <= qout +1;
		end
	end
	
	assign tc = (qout == mod) & enable;	
	
endmodule
