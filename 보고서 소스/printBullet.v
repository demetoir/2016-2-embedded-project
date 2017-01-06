module printBullet (
	input wire [9:0] px,
	input wire [9:0] py,
	input wire [4:0] leftBullet,
	output reg [9:0] r,
	output reg [9:0] g,
	output reg [9:0] b,
	output wire isPrinted
);
	
	parameter VGA_RGB_NULL = 10'h400;
	
	parameter max_bullet_number = 6;
	parameter bulletSize_X 		= 10;
	parameter bulletSize_Y 		= 20;		
	parameter bullet_x 			= 320;
	parameter bullet_y 			= 450;
	parameter bullet_Gap 		= 40;
	
	integer i;
	
	assign isPrinted = (r != VGA_RGB_NULL || g != VGA_RGB_NULL || b != VGA_RGB_NULL );
	always @(px, py) begin
		r = VGA_RGB_NULL;
		g = VGA_RGB_NULL;
		b = VGA_RGB_NULL;
		
		for( i = 1; i<= max_bullet_number; i = i + 1)begin 
			if (leftBullet >= i)begin 
				if(    px >= bullet_x + bullet_Gap * i - bulletSize_X  
					&& px <= bullet_x + bullet_Gap * i + bulletSize_X 
					&& py >= bullet_y - bulletSize_Y
					&& py <= bullet_y + bulletSize_Y) 
				begin 
					r = 10'h2cc;
					g = 10'h2cc;
					b = 10'h066;	
				end 
			end				
		end				
	
	end

endmodule 
