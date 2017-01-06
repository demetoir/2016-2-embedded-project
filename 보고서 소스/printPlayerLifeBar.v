module printPlayerLifeBar (
	input wire [9:0] px,
	input wire [9:0] py,
	input wire [9:0] PlayerLifePoint,
	output reg [9:0] r,
	output reg [9:0] g,
	output reg [9:0] b,
	output wire isPrinted
);
	parameter VGA_RGB_NULL = 10'h400;
	parameter MAX_PLAYER_LIFE_POINT = 100;
	//color : red
	parameter red_R 				= 10'h3ff;
	parameter red_G 				= 10'h0;
	parameter red_B 				= 10'h0;
	
	parameter lifeBarSize_Y 	= 20;
	parameter lifeBar_left 		= 70;
	parameter lifebar_mid 		= 450;
	
	integer i;
	assign isPrinted = (r != VGA_RGB_NULL || g != VGA_RGB_NULL || b != VGA_RGB_NULL );
	
	//lifeBar를 출력하는 부분 
	always @(px, py) begin
		r = VGA_RGB_NULL;
		g = VGA_RGB_NULL;
		b = VGA_RGB_NULL;
		
		for (i = 1; i <= MAX_PLAYER_LIFE_POINT; i = i + 1)begin 
			if ( PlayerLifePoint >= i) begin 
				if(    px >= lifeBar_left  
					&& px <= lifeBar_left + i*2
					&& py >= lifebar_mid - lifeBarSize_Y 
					&& py <= lifebar_mid + lifeBarSize_Y ) 
				begin 
					r = red_R;
					g = red_G;
					b = red_B;	
				end 
			end 
		end	
	end
	

endmodule 



