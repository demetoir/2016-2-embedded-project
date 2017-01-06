module printMonster(
	input wire clk,
	input wire [9:0] px,
	input wire [9:0] py,
	input wire [31:0] distValue,
	input wire [31:0] window_index,
	input wire isMonsterHit,
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

	
	reg [2:0] mouthSizeDiv;
	integer count;
	//for real time
	parameter mod_1hz = 5000000;
	parameter max_hitEffectTime = 2;
	
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
	
	//괴물의 입크기를 시간에 따라 달리하도록 만든다
	//플레이어가 피격될 수 있는 거리에 있는 경우 입의 크기가 변하는 속도가 빨라진다
	always @(posedge wire_tc_Hz1) begin
		count = count + 1;
		if (distValue == 0) begin
			count  = 0;
			if (mouthSizeDiv == 1) 
				mouthSizeDiv = 2;
			else 
				mouthSizeDiv = 1;
		end
		else if(distValue != 0) begin
			if (count == 5)begin
				count = 0;
				if (mouthSizeDiv == 1) 
					mouthSizeDiv = 2;
				else 
					mouthSizeDiv = 1;
			end
		end
	end
	
	//몬스터가 피격되었을때 나오는 피격이펙트이 시작과 끝을 처리한다 
	reg isHitEffect;
	always @(posedge clk)begin
		if (isMonsterHit) begin
			isHitEffect = 1;
		end
		
		if(isEndHitEffect)begin
			isHitEffect = 0;
		end
	end
	
	//몬스터의 피격이펙트의 표시하는 시간을 처리한다
	integer hitEffectTime;
	reg isEndHitEffect;
	always @(posedge clk)begin
		isEndHitEffect = 0;
		if(wire_tc_Hz1)begin		
			if (isHitEffect)begin
				hitEffectTime = hitEffectTime + 1;
			end
			
			if (hitEffectTime == max_hitEffectTime) begin
				hitEffectTime = 0;
				isEndHitEffect = 1;
			end		
		end
	end
	

	// 출력함을 표시하는 신호를 처리한다
	assign isPrinted = (r != VGA_RGB_NULL || g != VGA_RGB_NULL || b != VGA_RGB_NULL );
	always @(posedge clk) begin
		r = VGA_RGB_NULL;
		g = VGA_RGB_NULL;
		b = VGA_RGB_NULL;
		
		//print monster body
		begin
			//window_index에 따라 표시되는 위치가 달라지도록 만든다
			monster_body_x 		= 50 + 90 * window_index;
			monster_body_y 		= 210;
			//거리에 따라 표시도는 괴물의 크기를 달리한다
			monster_body_left 	= monster_body_x - (monsterBodySize_x - distValue*3);
			monster_body_right	= monster_body_x + (monsterBodySize_x - distValue*3);
			monster_body_top 	= monster_body_y - (monsterBodySize_y - distValue*6);
			monster_body_bottom = monster_body_y + (monsterBodySize_y - distValue*6);					
			if (   px >= monster_body_left 
				&& px <= monster_body_right
				&& py >= monster_body_top 
				&& py <= monster_body_bottom) 
			begin
				r = 10'h0;
				g = 10'h3ff;
				b = 10'h0;	
				
				//피격이펙트시 이펙트가 반복되어 표시되도록 만든다
				if ( isHitEffect ) begin
					if (hitEffectTime%2 ==0) begin
						r = 10'h2ff;
						g = 10'h1ff;
						b = 10'h0;	
					end
				end
			end
		end
		
		// print eye
		begin 
			//print monster left eye
			monster_left_eye_x 		= (monster_body_right - monster_body_left)/4 + monster_body_left;
			monster_left_eye_y		= (monster_body_bottom - monster_body_top)/4 + monster_body_top;
			monster_left_eye_left 	= monster_left_eye_x - (monsterEyeSize - distValue  );
			monster_left_eye_right 	= monster_left_eye_x + (monsterEyeSize - distValue  );
			monster_left_eye_top 	= monster_left_eye_y - (monsterEyeSize - distValue  );
			monster_left_eye_bottom = monster_left_eye_y + (monsterEyeSize - distValue  );		
			if (   px >= monster_left_eye_left 
				&& px <= monster_left_eye_right
				&& py >= monster_left_eye_top 
				&& py <= monster_left_eye_bottom) 					
			begin
				r = 10'h0;
				g = 10'h0;
				b = 10'h0;	
				
				if ( isHitEffect ) begin
					if (hitEffectTime%2 == 0) begin
						r = 10'h3ff;
						g = 10'h0;
						b = 10'h0;	
					end
					else begin
						r = 10'h0;
						g = 10'h0;
						b = 10'h3ff;	
					end
				end
			end
					
			// //print monster right eye
			monster_right_eye_x 		= ((monster_body_right - monster_body_left)/4)*3 + monster_body_left;
			monster_right_eye_y			= (monster_body_bottom - monster_body_top)/4 + monster_body_top;
			monster_right_eye_left 		= monster_right_eye_x - (monsterEyeSize - distValue  );
			monster_right_eye_right 	= monster_right_eye_x + (monsterEyeSize - distValue  );
			monster_right_eye_top 		= monster_right_eye_y - (monsterEyeSize - distValue  );
			monster_right_eye_bottom 	= monster_right_eye_y + (monsterEyeSize - distValue  );		
			if (   px >= monster_right_eye_left 
				&& px <= monster_right_eye_right
				&& py >= monster_right_eye_top 
				&& py <= monster_right_eye_bottom) 					
			begin
				r = 10'h0;
				g = 10'h0;
				b = 10'h0;	
				
				if ( isHitEffect ) begin
					if (hitEffectTime%2 == 1) begin
						r = 10'h3ff;
						g = 10'h0;
						b = 10'h0;	
					end
					else begin
						r = 10'h0;
						g = 10'h0;
						b = 10'h3ff;	
					end
				end
			end
		end
		
		//print monster mouth
		begin 
			monster_mouth_x 		= (monster_body_right - monster_body_left)/2 + monster_body_left;
			monster_mouth_y			= ((monster_body_bottom - monster_body_top)/4)*3 + monster_body_top;
			monster_mouth_left 		= monster_mouth_x - (monsterMouthSize - distValue *3 )/mouthSizeDiv;
			monster_mouth_right 	= monster_mouth_x + (monsterMouthSize - distValue *3 )/mouthSizeDiv;
			monster_mouth_top 		= monster_mouth_y - (monsterMouthSize - distValue *3 )/mouthSizeDiv;
			monster_mouth_bottom 	= monster_mouth_y + (monsterMouthSize - distValue *3 )/mouthSizeDiv;		
			if (   px >= monster_mouth_left 
				&& px <= monster_mouth_right
				&& py >= monster_mouth_top 
				&& py <= monster_mouth_bottom) 					
			begin
				r = 10'h3ff;
				g = 10'h0;
				b = 10'h0;
			end	
		end
	end

endmodule

