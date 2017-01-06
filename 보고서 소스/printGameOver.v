module printGameOver(
	input wire clk,
	input wire [9:0] px,
	input wire [9:0] py,
	input wire [9:0] PlayerLifePoint,
	output reg [9:0] r,
	output reg [9:0] g,
	output reg [9:0] b,
	output wire isPrinted
	);

	parameter VGA_RGB_NULL = 10'h400;
		
	parameter monsterBodySize_x  = 45;
	parameter monsterBodySize_y  = 90;
	parameter monsterEyeSize	= 15;
	parameter monsterMouthSize 	= 40;
	
	integer monster_body_x;
	integer monster_body_y;
	integer monster_body_left;
	integer monster_body_right;
	integer monster_body_top;
	integer monster_body_bottom;	
	
	integer monster_left_eye_x;
	integer monster_left_eye_y;	
	integer monster_left_eye_left;
	integer monster_left_eye_right;
	integer monster_left_eye_top;
	integer monster_left_eye_bottom;
	
	integer monster_right_eye_x;
	integer monster_right_eye_y;
	integer monster_right_eye_left;
	integer monster_right_eye_right;
	integer monster_right_eye_top;
	integer monster_right_eye_bottom;
	
	integer monster_mouth_x;
	integer monster_mouth_y;
	integer monster_mouth_left;
	integer monster_mouth_right;
	integer monster_mouth_top;
	integer monster_mouth_bottom;

	
	//for real time
	parameter mod_1hz = 50000000;
	//for simulation
	//parameter mod_10hz = 2;
	wire wire_tc_Hz1;
	counter #( mod_1hz ) module_Hz1_counter (
		.qout		(), 
		.tc			(wire_tc_Hz1), 
		.enable		(1),
		.load		(0),
		.din		(0),
		.reset		(0),
		.clk		(clk)
	);	
	
	//1Hz tc counter를 이용하여 주기적으로 입이 열렸다 닫혔다 하도록 만든다
	reg isMouthOpen;
	always @(posedge wire_tc_Hz1) begin
		isMouthOpen = ~isMouthOpen;
	end
	
	parameter teethSize = 110;
	parameter monster_up_teeth_y = 120;
	parameter monster_down_teeth_y = 360;
	
	
	assign isPrinted = (r != VGA_RGB_NULL || g != VGA_RGB_NULL || b != VGA_RGB_NULL );
	integer i;
	always @(posedge clk) begin
		r = VGA_RGB_NULL;
		g = VGA_RGB_NULL;
		b = VGA_RGB_NULL;
		
		if (PlayerLifePoint == 0) begin
			r = 10'h3ff;
			g = 10'h0;
			b = 10'h0;	
			
			//draw tooth
			//isMouthOpen이 0이면 입이 열리고 1이면 닫힘을 그리도록 한다
			if(	py <= monster_up_teeth_y + teethSize*isMouthOpen|| 
				py >= monster_down_teeth_y - teethSize*isMouthOpen)
			begin
				r = 10'h3ff;
				g = 10'h3ff;
				b = 10'h3ff;	
				//이빨의 경계선을 그린다
				if ( px % 40 == 0)begin
					r = 10'h0;
					g = 10'h0;
					b = 10'h0;	
				end
			end
			
			//draw mouth
			if(py <= 80 || py >= 400 ) begin
				r = 10'h0;
				g = 10'h3ff;
				b = 10'h0;
			end
		end
	end

endmodule
