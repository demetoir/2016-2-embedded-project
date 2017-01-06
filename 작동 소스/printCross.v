module printCross(	
	input wire [9:0] px,
	input wire [9:0] py,
	output reg [9:0] r,
	output reg [9:0] g,
	output reg [9:0] b,
	output wire isPrinted
	);
	
	parameter NULL_Value 		= 10'h400;
	parameter crossSize			= 2;
	parameter red_cross_size 	= crossSize;
	parameter black_cross_size 	= red_cross_size/3;		
	
	assign isPrinted = (r != NULL_Value || g != NULL_Value || b != NULL_Value); 
	always @(px, py) begin
		r = NULL_Value;
		g = NULL_Value;
		b = NULL_Value;		
		//print red cross horizon
		if (   py >= 205 
			&& py <= 225
			&& px >= 320 - red_cross_size 
			&& px <= 320 + red_cross_size ) 
		begin
			r = 10'h0;
			g = 10'h0;
			b = 10'h3ff;		
		end
		
		//print red cross vertical
		if (   px >= 310 
			&& px <= 330 
			&& py >= 215 - red_cross_size 
			&& py <= 215 + red_cross_size )
		begin
			r = 10'h0;
			g = 10'h0;
			b = 10'h3ff;	
		end
		
		//print black cross horizon
		if (   py >= 205 
			&& py <= 225
			&& px >= 320 - black_cross_size 
			&& px <= 320 + black_cross_size ) 
		begin
			r = 10'h0;
			g = 10'h0;
			b = 10'h0;	
		end
		
		//print black cross vertical
		if (   px >= 310 
			&& px <= 330 
			&& py >= 215 - black_cross_size 
			&& py <= 215 + black_cross_size )
		begin
			r = 10'h0;
			g = 10'h0;
			b = 10'h0;		
		end
	end		

endmodule



