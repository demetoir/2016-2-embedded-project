module VGA_data(
	input wire clk, 
	input wire reset,
	input wire [9:0] px,
	input wire [9:0] py,
	
	input wire [4:0] distvalue0,
	input wire [4:0] distvalue1,
	input wire [4:0] distvalue2,
	input wire [4:0] distvalue3,
	input wire [4:0] distvalue4,
	input wire [4:0] distvalue5,
	input wire [4:0] distvalue6,	
	input wire [9:0] PlayerLifePoint,
	input wire [4:0] leftBullet,
	
	input wire isGunFired,
	input wire isMonsterHit,
	
	output reg [9:0] r,
	output reg [9:0] g,
	output reg [9:0] b	
);

	parameter MAX_PLAYER_LIFE_POINT = 100;
	parameter gunSizeX = 15;
	parameter gunSizeY = 70;
	integer gunx;
	integer guny;
	integer gun_left;
	integer gun_right;
	integer gun_top;
	integer gun_bottom;
	
	parameter fireEffectSize1 = 7 ;
	parameter fireEffectSize2 = 14;
	parameter fireEffectSize3 = 21;	
	integer gun_fireEffect_left;
	integer gun_fireEffect_right;
	integer gun_fireEffect_top;
	integer gun_fireEffect_bottom;
		
		
	// update vga rgb
	wire [9:0] monster0_r;
	wire [9:0] monster0_g;
	wire [9:0] monster0_b;
	wire isPrinted_monster0;
	printMonster module_printMonster0(
		.clk(clk),
		.px(px),
		.py(py),
		.distValue(distvalue0),
		.window_index(0),
		.r(monster0_r),
		.g(monster0_g),
		.b(monster0_b),
		.isPrinted(isPrinted_monster0)
	);
	
	wire [9:0] monster1_r;
	wire [9:0] monster1_g;
	wire [9:0] monster1_b;
	wire isPrinted_monster1;
	printMonster module_printMonster1(
		.clk(clk),
		.px(px),
		.py(py),
		.distValue(distvalue1),
		.window_index(1),
		.r(monster1_r),
		.g(monster1_g),
		.b(monster1_b),
		.isPrinted(isPrinted_monster1)
	);
	
	wire [9:0] monster2_r;
	wire [9:0] monster2_g;
	wire [9:0] monster2_b;
	wire isPrinted_monster2;
	printMonster module_printMonster2(
		.clk(clk),
		.px(px),
		.py(py),
		.distValue(distvalue2),
		.window_index(2),
		.r(monster2_r),
		.g(monster2_g),
		.b(monster2_b),
		.isPrinted(isPrinted_monster2)
	);
	
	wire [9:0] monster3_r;
	wire [9:0] monster3_g;
	wire [9:0] monster3_b;
	wire isPrinted_monster3;
	printMonster module_printMonster3(
		.clk(clk),
		.px(px),
		.py(py),
		.distValue(distvalue3),
		.isMonsterHit(isMonsterHit),
		.window_index(3),
		.r(monster3_r),
		.g(monster3_g),
		.b(monster3_b),
		.isPrinted(isPrinted_monster3)
	);
	
	wire [9:0] monster4_r;
	wire [9:0] monster4_g;
	wire [9:0] monster4_b;
	wire isPrinted_monster4;
	printMonster module_printMonster4(
		.clk(clk),
		.px(px),
		.py(py),
		.distValue(distvalue4),
		.window_index(4),
		.r(monster4_r),
		.g(monster4_g),
		.b(monster4_b),
		.isPrinted(isPrinted_monster4)
	);
	
	wire [9:0] monster5_r;
	wire [9:0] monster5_g;
	wire [9:0] monster5_b;
	wire isPrinted_monster5;
	printMonster module_printMonster5(
		.clk(clk),
		.px(px),
		.py(py),
		.distValue(distvalue5),
		.window_index(5),
		.r(monster5_r),
		.g(monster5_g),
		.b(monster5_b),
		.isPrinted(isPrinted_monster5)
	);
	
	wire [9:0] monster6_r;
	wire [9:0] monster6_g;
	wire [9:0] monster6_b;
	wire isPrinted_monster6;
	printMonster module_printMonster6(
		.clk(clk),
		.px(px),
		.py(py),
		.distValue(distvalue6),
		.window_index(6),
		.r(monster6_r),
		.g(monster6_g),
		.b(monster6_b),
		.isPrinted(isPrinted_monster6)
	);
	
	wire [9:0] PlayerLifeBar_r;
	wire [9:0] PlayerLifeBar_g;
	wire [9:0] PlayerLifeBar_b;
	wire isPrint_PlayerLifeBar;
	printPlayerLifeBar 
		#(	.MAX_PLAYER_LIFE_POINT(MAX_PLAYER_LIFE_POINT)
		)
		module_printPlayerLifeBar(
		.px(px),
		.py(py),
		.PlayerLifePoint(PlayerLifePoint),
		.r(PlayerLifeBar_r),
		.g(PlayerLifeBar_g),
		.b(PlayerLifeBar_b),
		.isPrinted(isPrint_PlayerLifeBar)
	);
		
	wire [9:0] Bullet_r;
	wire [9:0] Bullet_g;
	wire [9:0] Bullet_b;
	wire isPrint_Bullet;
	printBullet 
		#(.max_bullet_number(6))
		module_printBullet(
		.px(px),
		.py(py),
		.leftBullet(leftBullet),
		.r(Bullet_r),
		.g(Bullet_g),
		.b(Bullet_b),
		.isPrinted(isPrint_Bullet)
	);
			
	wire [9:0] cross_r;
	wire [9:0] cross_g;
	wire [9:0] cross_b;
	wire isPrinted_cross;		
	printCross	
		module_PrintCross(	
		.px(px),
		.py(py),
		.r(cross_r),
		.g(cross_g),
		.b(cross_b),
		.isPrinted(isPrinted_cross)
	);	
			
	wire [9:0] gameOver_r;
	wire [9:0] gameOver_g;
	wire [9:0] gameOver_b;
	wire isPrinted_GameOver;
	printGameOver
		module_printGameOver(
		.clk(clk),
		.PlayerLifePoint(PlayerLifePoint),
		.px(px),
		.py(py),
		.r(gameOver_r),
		.g(gameOver_g),
		.b(gameOver_b),
		.isPrinted(isPrinted_GameOver)
	);		
			
			
	always @(posedge clk) begin	
		r = 10'h0;
		g = 10'h0;
		b = 10'h0;
		
		if(PlayerLifePoint != 0) begin				
			//print monster
			begin
				if (isPrinted_monster0 ) begin
					{r, g, b} = {monster0_r, monster0_g, monster0_b};
				end				
				if (isPrinted_monster1 ) begin
					{r, g, b} = {monster1_r, monster1_g, monster1_b};
				end				
				if (isPrinted_monster2 ) begin
					{r, g, b} = {monster2_r, monster2_g, monster2_b};
				end				
				if ( isPrinted_monster3 ) begin
					{r, g, b} = {monster3_r, monster3_g, monster3_b};
				end				
				if (isPrinted_monster4 ) begin
					{r, g, b} = {monster4_r, monster4_g, monster4_b};
				end				
				if (isPrinted_monster5 ) begin
					{r, g, b} = {monster5_r, monster5_g, monster5_b};
				end				
				if (isPrinted_monster6 ) begin
					{r, g, b} = {monster6_r, monster6_g, monster6_b};
				end				
			end
						
			//print playerLifeBar
			if (isPrint_PlayerLifeBar) begin
				{r, g, b} = {PlayerLifeBar_r, PlayerLifeBar_g, PlayerLifeBar_b};
			end
			
			//print bullet
			if(isPrint_Bullet) begin
				{r, g, b} = {Bullet_r, Bullet_g, Bullet_b};
			end
			
			//print cross
			if (isPrinted_cross) begin
				{r, g, b} = {cross_r, cross_g, cross_b};
			end	
		end 
		//플레이어의 체력이 없다면 game over화면을 출력한다
		else begin
			if(isPrinted_GameOver) begin
				r = gameOver_r;
				g = gameOver_g;
				b = gameOver_b;
			end
		end
	end

	
endmodule






