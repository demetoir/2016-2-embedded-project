module topModule (
		////////////////////	Clock Input	 	////////////////////	 
		topIN_clk_27,						//	27 MHz
		topIN_clk_50,						//	50 MHz
		////////////////////	Push Button		////////////////////
		topIN_KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		topIN_SW,								//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		topOUT_HEX0,							//	Seven Segment Digit 0
		topOUT_HEX1,							//	Seven Segment Digit 1
		topOUT_HEX2,							//	Seven Segment Digit 2
		topOUT_HEX3,							//	Seven Segment Digit 3
		topOUT_HEX4,							//	Seven Segment Digit 4
		topOUT_HEX5,							//	Seven Segment Digit 5
		topOUT_HEX6,							//	Seven Segment Digit 6
		topOUT_HEX7,							//	Seven Segment Digit 7
		////////////////////////	LED		////////////////////////
		topOUT_LEDG,							//	LED Green[8:0]
		topOUT_LEDR,							//	LED Red[17:0]	
		////////////////////	VGA		////////////////////////////
		topOUT_VGA_CLK,   						//	VGA Clock
		topOUT_VGA_HS,							//	VGA H_SYNC
		topOUT_VGA_VS,							//	VGA V_SYNC
		topOUT_VGA_BLANK,						//	VGA BLANK
		topOUT_VGA_SYNC,						//	VGA SYNC
		topOUT_VGA_R,   						//	VGA Red[9:0]
		topOUT_VGA_G,	 						//	VGA Green[9:0]
		topOUT_VGA_B,  							//	VGA Blue[9:0]
		//////////////////////////  PS/2              ////////////////////////////
		topIN_PS2_CLK,
		topIN_PS2_DATA
	);

	////////////////////////	Clock Input	 	////////////////////////
	input			topIN_clk_27;				//	27 MHz
	input			topIN_clk_50;				//	50 MHz
	////////////////////////	Push Button		////////////////////////
	input	[3:0]	topIN_KEY;					//	Pushbutton[3:0]
	////////////////////////	DPDT Switch		////////////////////////
	input	[17:0]	topIN_SW;						//	Toggle Switch[17:0]
	////////////////////////	7-SEG Dispaly	////////////////////////
	output	[6:0]	topOUT_HEX0;					//	Seven Segment Digit 0
	output	[6:0]	topOUT_HEX1;					//	Seven Segment Digit 1
	output	[6:0]	topOUT_HEX2;					//	Seven Segment Digit 2
	output	[6:0]	topOUT_HEX3;					//	Seven Segment Digit 3
	output	[6:0]	topOUT_HEX4;					//	Seven Segment Digit 4
	output	[6:0]	topOUT_HEX5;					//	Seven Segment Digit 5
	output	[6:0]	topOUT_HEX6;					//	Seven Segment Digit 6
	output	[6:0]	topOUT_HEX7;					//	Seven Segment Digit 7
	////////////////////////////	LED		////////////////////////////
	output	[8:0]	topOUT_LEDG;					//	LED Green[8:0]
	output	[17:0]	topOUT_LEDR;					//	LED Red[17:0]

	////////////////////////	VGA			////////////////////////////
	output				topOUT_VGA_CLK;   			//	VGA Clock
	output				topOUT_VGA_HS;				//	VGA H_SYNC
	output				topOUT_VGA_VS;				//	VGA V_SYNC
	output				topOUT_VGA_BLANK;			//	VGA BLANK
	output				topOUT_VGA_SYNC;			//	VGA SYNC
	output	 [9:0]		topOUT_VGA_R;   			//	VGA Red[9:0]
	output	 [9:0]		topOUT_VGA_G;	 			//	VGA Green[9:0]
	output	 [9:0]		topOUT_VGA_B;   			//	VGA Blue[9:0]
	input				topIN_PS2_CLK;
	input 				topIN_PS2_DATA;

	//	Turn on all display
	assign	topOUT_HEX0		=	7'hff;
	assign	topOUT_HEX1		=	7'h00;
	assign	topOUT_HEX2		=	7'hff;
	assign	topOUT_HEX3		=	7'h00;
	assign	topOUT_HEX4		=	7'h00;
	assign	topOUT_HEX5		=	7'h00;
	assign	topOUT_HEX6		=	7'h00;
	assign	topOUT_HEX7		=	7'h00;
	
	integer i;

	//reset switch
	wire 	wire_reset;
	assign 	wire_reset = topIN_SW[0];		
	// end reset switch
		
	//monster regen module part
	wire isMonsterRegen;
	wire [4:0] wire_monster_genrator_index;
	monster_generator module_moster_generator(
		.clk(topIN_clk_50),
		.reset(wire_reset),
		.isMonsterRegen(isMonsterRegen),
		.monster_generator_index(wire_monster_genrator_index)
	);
	//end monster regen module part
		
	// keyboard input part
	reg 	[7:0] reg_keycode;
	wire 	wire_ps2_done;
	wire 	[7:0] wire_ps2_data;
	reg 	reg_ps2_reset;
	wire 	wire_ps2_reset = reg_ps2_reset;
	wire 	isKeyup;
	ps2_recv   module_ps2_recv(
		.clk			(topIN_clk_50), 
		.reset			(wire_ps2_reset),
		.ps2d			(topIN_PS2_DATA), 
		.ps2c			(topIN_PS2_CLK),        
		.scan_code		(wire_ps2_data),        
		.scan_code_ready(wire_ps2_done)
	);	
	
	//keyboard input router
	integer prev_scancode;
	always @(posedge topIN_clk_50) begin
		if (wire_reset) begin 
			debug_test_key_count = 0;
			debug_keyCount = 0;
			reg_keycode = 0;
			prev_scancode = 0;
		end	
		
		//키보드 입력이 들어왔을 경우 조작키에 맞는 신호를 발생시킨다
		if (wire_ps2_done) begin		
			reg_PlayerTurnRight = 0;
			reg_PlayerTurnLeft = 0;
			reg_PlayerGoForward = 0;
			reg_PlayerGoBackward = 0;
			reg_isTryToReload = 0;
			reg_isTryToFire	 = 0;	
			
			//키가 계속 눌려 scan_code가 발생한경우는 무시한다
			if(prev_scancode != wire_ps2_data)begin
				prev_scancode = wire_ps2_data;
				case (wire_ps2_data)			
				playerMoveLeft : begin 
					reg_PlayerTurnRight = 1;
				end	
				playerMoveRight : begin 
					reg_PlayerTurnLeft = 1;
				end			
				playerMoveForward : begin
					reg_PlayerGoForward = 1;
				end
				playerMoveBackward : begin
					reg_PlayerGoBackward = 1;
				end
				playerTryFire : begin				
					reg_isTryToFire = 1;		
				end	
				playerTryReloadGun : begin
					reg_isTryToReload = 1;
				end		
				// breakcode를 받았을떄는 키를 뗀것이므로 prev_scancode를 초기화한다
				breakcode: begin 
					prev_scancode = 0;
				end
				default : debug_reg_KEY_VALUE <= 5'b00000;
				endcase	
			end				
		end
	end	
	//end keyboard input router
	
	
	// end keyboard input part
		
	//    VGA controller start
	//clk25 for vga controller 
	reg CLK25;		
	always @( posedge topIN_clk_50 or posedge wire_reset )begin 
		if ( wire_reset ) begin
			CLK25 <= 0;
		end
		else begin 
			CLK25 <= ~CLK25;
		end
	end	
	
	wire [9:0] wire_in_r, wire_in_g, wire_in_b;	
	wire [9:0] wire_px, wire_py;

	//vga controller module
	VGA_CONTROLLER 
		module_vga_controller( 
		CLK25, 
		wire_reset, 
		wire_in_r, 
		wire_in_g, 
		wire_in_b, 
		wire_px, 
		wire_py, 
		topOUT_VGA_R, 
		topOUT_VGA_G, 
		topOUT_VGA_B, 
		topOUT_VGA_HS, 
		topOUT_VGA_VS, 
		topOUT_VGA_SYNC, 
		topOUT_VGA_BLANK, 
		topOUT_VGA_CLK 
	);		
	
	VGA_data 
		module_VGA_data(
		.clk(topIN_clk_50), 
		.reset(wire_reset),
		.px(wire_px),
		.py(wire_py),
		.distvalue0(window0_Monster_distValue),
		.distvalue1(window1_Monster_distValue),
		.distvalue2(window2_Monster_distValue),
		.distvalue3(window3_Monster_distValue),
		.distvalue4(window4_Monster_distValue),
		.distvalue5(window5_Monster_distValue),
		.distvalue6(window6_Monster_distValue),
				
		.PlayerLifePoint(PlayerLifePoint),
		.leftBullet(leftBullet),		
		.isGunFired(isGunFired),
		.isMonsterHit( isMonsterHit ),	
		.r(wire_in_r),
		.g(wire_in_g),
		.b(wire_in_b)	
	);
	//	end VGA controller start
		
		
	//  game data 	
	parameter 	gun_ap 				= 10;
	parameter 	monster_ap			= 3;
	parameter 	playerMoveLeft 		= 8'b0110_1011,
				playerMoveRight		= 8'b0111_0100,
				playerMoveForward 	= 8'b0111_0011,
				playerMoveBackward	= 8'b0111_0101,
				playerTryFire		= 8'b0010_1001,
				breakcode 			= 8'b1111_0000,
				playerTryReloadGun 	= 8'b0010_1101;
	
	
	//reset default life point = 100;
	//max life poiny = 100
	parameter MAX_PLAYER_LIFE_POINT = 100;
	wire isPlayerDead;
	wire [9:0] PlayerLifePoint ;
	wire isPlayerDamaged;	
	lifePoint_data  
		#( 	.resetLifePoint(MAX_PLAYER_LIFE_POINT), 
			.maxLifePoint(MAX_PLAYER_LIFE_POINT) 
		)
		module_lifePoint_data_PlayerLife(
		.clk(topIN_clk_50),
		.reset(wire_reset),
		.isRegen(0),
		.isDamaged(isPlayerDamaged),
		.damagedValue(totalMonsterDamageToPlayer),
		.lifePoint(PlayerLifePoint),
		.isDead(isPlayerDead)
	);		
	
	// end
		
	reg reg_isTryToFire;
	reg reg_isTryToReload;	
	reg reg_PlayerTurnRight;
	reg reg_PlayerTurnLeft;
	reg reg_PlayerGoForward;
	reg	reg_PlayerGoBackward;
	
	wire wire_isTryToFire = reg_isTryToFire;
	wire wire_isTryToReload = reg_isTryToReload;
	wire wire_PlayerTurnRight = reg_PlayerTurnRight;
	wire wire_PlayerTurnLeft = reg_PlayerTurnLeft;
	wire wire_PlayerGoForward = reg_PlayerGoForward;
	wire wire_PlayerGoBackward = reg_PlayerGoBackward;
		
	wire [4:0] leftBullet;
	wire isGunFired;	
	weapon module_PlayerWeapon(
		.clk(topIN_clk_50),
		.reset(wire_reset),
		.isTryToFire(wire_isTryToFire),
		.isTryToReload(wire_isTryToReload),
		.leftBullet(leftBullet),
		.isFired(isGunFired)
	);	
		

	
	wire [4:0] window0_Monster_distValue;
	wire [4:0] window1_Monster_distValue;
	wire [4:0] window2_Monster_distValue;
	wire [4:0] window3_Monster_distValue;
	wire [4:0] window4_Monster_distValue;
	wire [4:0] window5_Monster_distValue;
	wire [4:0] window6_Monster_distValue;
	wire isMonsterHit;
	
	wire [9:0] totalMonsterDamageToPlayer;
	setOfMonster_data module_setOfMonster_data(
		
		.clk(topIN_clk_50),
		.reset(wire_reset), 
		
		.playerMoveLeft(wire_PlayerTurnLeft),
		.playerMoveRight(wire_PlayerTurnRight),
		.playerMoveForward(wire_PlayerGoForward),
		.playerMoveBackward(wire_PlayerGoBackward),
		//input wire monster_move,
		.isGunFired(isGunFired),
		.GunDamageValue(5),
		
		.isMonsterRegen(isMonsterRegen),
		.regenedMonsterCethaValue(wire_monster_genrator_index),
		
		.window0_Monster_distValue(window0_Monster_distValue),
		.window1_Monster_distValue(window1_Monster_distValue),
		.window2_Monster_distValue(window2_Monster_distValue),
		.window3_Monster_distValue(window3_Monster_distValue),
		.window4_Monster_distValue(window4_Monster_distValue),
		.window5_Monster_distValue(window5_Monster_distValue),
		.window6_Monster_distValue(window6_Monster_distValue),
		
		.isMonsterHit(isMonsterHit),
		.isPlayerDamaged(isPlayerDamaged),
		.totalMonsterDamageToPlayer(totalMonsterDamageToPlayer)
	);


		
	// #####  end game data 

		


		
	//for debug
	integer debug_test_key_count;
	reg [7:0] debug_keyCount;	
	reg [4:0] debug_reg_KEY_VALUE;
	//end debug
		
	//for debug value assign to LED Red, LED Green
	// assign topOUT_LEDR [16: 8] = {debug_test_key_count};	
	// assign topOUT_LEDR [7:0] = {reg_PlayerTurnLeft,reg_PlayerTurnRight,debug_keyCount};
	//assign topOUT_LEDR = {wire_distvalue0, wire_distvalue1, wire_distvalue2, wire_distvalue3};
	assign topOUT_LEDR = {isPlayerDead, PlayerLifePoint};
	//assign topOUT_LEDR[17: 14] = {wire_distvalue0};
	//assign topOUT_LEDR[13: 0] = {debug_test_key_count,debug_reg_KEY_VALUE};
	assign topOUT_LEDG [7:0] = {leftBullet};
	//assign topOUT_LEDR [17] =  (wire_ps2_data == 8'b1110_0000);
	// assign topOUT_LEDR [16:8] = { 
								// wire_targeIndex3[2:0],
								// wire_targeIndex0[2:0],
								// wire_targeIndex1[2:0],
								// wire_targeIndex0[2:0]};
	
 
endmodule














