module setOfMonster_data(
	input wire clk,								//50Mhz clk
	input wire reset, 							//reset signal
	input wire playerMoveLeft,					//player Move Left signal
	input wire playerMoveRight,					//playerMoveRight,
	input wire playerMoveForward,				//playerMoveForward
	input wire playerMoveBackward,				//playerMoveBackward
	input wire isGunFired,						//총 발사에대한 신호
	input wire [9:0] GunDamageValue,			//총의 데미지 양
	input wire isMonsterRegen,					//monster의 리젠 신호
	input wire [4:0] regenedMonsterCethaValue,	//monster가 리젠될 각도 
	output reg [4:0] window0_Monster_distValue, //화면 영역0~6까지 표시될 몬스터의 거리정보
	output reg [4:0] window1_Monster_distValue,
	output reg [4:0] window2_Monster_distValue,
	output reg [4:0] window3_Monster_distValue,
	output reg [4:0] window4_Monster_distValue,
	output reg [4:0] window5_Monster_distValue,
	output reg [4:0] window6_Monster_distValue,
	output reg isMonsterHit,					//monster의 피격 신호
	output reg isPlayerDamaged,					//player의 피격신호
	output reg [9:0] totalMonsterDamageToPlayer //player 피격된 총데미지양
);

	parameter MAX_monster_number 				= 10;
	parameter defalut_regen_monster_distValue 	= 10;
	parameter monster_ap						= 1;	
	parameter middle_cetha_value 				= 3;
	
	integer i ;
	
	parameter hitDelay = 3;
	integer delayCount;
	
	//for real time
	parameter mod_10hz = 5000000;
	//for simulation
	//parameter mod_10hz = 2;
	wire wire_tc_Hz10;
	counter #( mod_10hz ) module_Hz10_counter (
		.qout		(), 
		.tc			(wire_tc_Hz10), 
		.enable		(1),
		.load		(0),
		.din		(0),
		.reset		(0),
		.clk		(clk)
	);	
	
	//for real time
	parameter mod_1hz = 50000000;
	//for simulation
	//parameter mod_1hz = 4;
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
		
	
	reg [9:0] reg_regenedMonsterArray;
	wire [9:0] regenedMonsterArray = reg_regenedMonsterArray;
	reg [9:0] reg_DamagedMonsterArray ;
	wire [9:0] wire_DamagedMonsterArray = reg_DamagedMonsterArray;
	wire [9:0] isMonsterDeadArray;	
	wire [9:0] isMonsterNHitPlayer;
	wire [9:0] isMonsterInMiddle;
	
	assign isMonsterInMiddle[0] = (monster0_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[1] = (monster1_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[2] = (monster2_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[3] = (monster3_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[4] = (monster4_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[5] = (monster5_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[6] = (monster6_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[7] = (monster7_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[8] = (monster8_cethaValue == middle_cetha_value);
	assign isMonsterInMiddle[9] = (monster9_cethaValue == middle_cetha_value);
	
	assign isMonsterNHitPlayer[0] = (monster0_distValue == 0 && isMonsterDeadArray[0] == 0 );
	assign isMonsterNHitPlayer[1] = (monster1_distValue == 0 && isMonsterDeadArray[1] == 0 );
	assign isMonsterNHitPlayer[2] = (monster2_distValue == 0 && isMonsterDeadArray[2] == 0 );
	assign isMonsterNHitPlayer[3] = (monster3_distValue == 0 && isMonsterDeadArray[3] == 0 );
	assign isMonsterNHitPlayer[4] = (monster4_distValue == 0 && isMonsterDeadArray[4] == 0 );
	assign isMonsterNHitPlayer[5] = (monster5_distValue == 0 && isMonsterDeadArray[5] == 0 );
	assign isMonsterNHitPlayer[6] = (monster6_distValue == 0 && isMonsterDeadArray[6] == 0 );
	assign isMonsterNHitPlayer[7] = (monster7_distValue == 0 && isMonsterDeadArray[7] == 0 );
	assign isMonsterNHitPlayer[8] = (monster8_distValue == 0 && isMonsterDeadArray[8] == 0 );
	assign isMonsterNHitPlayer[9] = (monster9_distValue == 0 && isMonsterDeadArray[9] == 0 );

	
	wire [4:0] monster0_distValue;
	wire [4:0] monster0_cethaValue;	
	wire [9:0] monster0_lifePoint;
	
	monster_data
		module_monster0(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		//monster damaged
		.isDamaged(wire_DamagedMonsterArray[0]),
		.DamagedValue(GunDamageValue),
		
		//monster regen
		.isMonsterRegen(regenedMonsterArray[0]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster0_lifePoint),
		.isDead(isMonsterDeadArray[0]),
		.monster_cethaValue(monster0_cethaValue),
		.monster_distValue(monster0_distValue)
	);
	
	wire [4:0] monster1_distValue;
	wire [4:0] monster1_cethaValue;	
	wire [9:0] monster1_lifePoint;
	monster_data
		module_monster1(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[1]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[1]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster1_lifePoint),
		.isDead(isMonsterDeadArray[1]),
		.monster_cethaValue(monster1_cethaValue),
		.monster_distValue(monster1_distValue)
	);
	
	wire [4:0] monster2_distValue;
	wire [4:0] monster2_cethaValue;	
	wire [9:0] monster2_lifePoint;
	monster_data
		module_monster2(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[2]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[2]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster2_lifePoint),
		.isDead(isMonsterDeadArray[2]),
		.monster_cethaValue(monster2_cethaValue),
		.monster_distValue(monster2_distValue)
	);
	
	wire [4:0] monster3_distValue;
	wire [4:0] monster3_cethaValue;	
	wire [9:0] monster3_lifePoint;
	monster_data
		module_monster3(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[3]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[3]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster3_lifePoint),
		.isDead(isMonsterDeadArray[3]),
		.monster_cethaValue(monster3_cethaValue),
		.monster_distValue(monster3_distValue)
	);
	
	wire [4:0] monster4_distValue;
	wire [4:0] monster4_cethaValue;	
	wire [9:0] monster4_lifePoint;
	monster_data
		module_monster4(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[4]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[4]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster4_lifePoint),
		.isDead(isMonsterDeadArray[4]),
		.monster_cethaValue(monster4_cethaValue),
		.monster_distValue(monster4_distValue)
	);
	
	wire [4:0] monster5_distValue;
	wire [4:0] monster5_cethaValue;	
	wire [9:0] monster5_lifePoint;
	monster_data
		module_monster5(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[5]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[5]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster5_lifePoint),
		.isDead(isMonsterDeadArray[5]),
		.monster_cethaValue(monster5_cethaValue),
		.monster_distValue(monster5_distValue)
	);
	
		
	wire [4:0] monster6_distValue;
	wire [4:0] monster6_cethaValue;	
	wire [9:0] monster6_lifePoint;
	monster_data
		module_monster6(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[6]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[6]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster6_lifePoint),
		.isDead(isMonsterDeadArray[6]),
		.monster_cethaValue(monster6_cethaValue),
		.monster_distValue(monster6_distValue)
	);
	
	wire [4:0] monster7_distValue;
	wire [4:0] monster7_cethaValue;	
	wire [9:0] monster7_lifePoint;
	monster_data
		module_monster7(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[7]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[7]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster7_lifePoint),
		.isDead(isMonsterDeadArray[7]),
		.monster_cethaValue(monster7_cethaValue),
		.monster_distValue(monster7_distValue)
	);
	
	wire [4:0] monster8_distValue;
	wire [4:0] monster8_cethaValue;	
	wire [9:0] monster8_lifePoint;
	monster_data
		module_monster8(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[8]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[8]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster8_lifePoint),
		.isDead(isMonsterDeadArray[8]),
		.monster_cethaValue(monster8_cethaValue),
		.monster_distValue(monster8_distValue)
	);
	
	wire [4:0] monster9_distValue;
	wire [4:0] monster9_cethaValue;	
	wire [9:0] monster9_lifePoint;
	monster_data
		module_monster9(
		.clk(clk),
		.reset(reset),		
		.playerMoveLeft(playerMoveLeft),
		.playerMoveRight(playerMoveRight),
		.playerMoveForward(playerMoveForward),
		.playerMoveBackward(playerMoveBackward),
		.monster_move(wire_tc_Hz1),
		
		.isDamaged(wire_DamagedMonsterArray[9]),
		.DamagedValue(GunDamageValue),
		
		.isMonsterRegen(regenedMonsterArray[9]),
		.regenCethaValue(regenedMonsterCethaValue),
		.regenDistValue(defalut_regen_monster_distValue),
		
		// output 
		.monster_lifePoint(monster9_lifePoint),
		.isDead(isMonsterDeadArray[9]),
		.monster_cethaValue(monster9_cethaValue),
		.monster_distValue(monster9_distValue)
	);

	
	
	reg isRegenMonsterFouned;
	integer tempDistVal;
	always @(posedge clk ) begin
		if(reset) begin
			delayCount = 0;
			totalMonsterDamageToPlayer = 0;
		end
		
		if(wire_tc_Hz10) begin
			delayCount = delayCount + 1;
		end
		
		//총이 발사되었을대 피격된 몬스터를 검색한다
		//총알은 몬스터를 관통하지 않으므로 총알에 피격되는 몬스터들중 distValue가
		//가장 작은 몬스터만 피격되어야한다
		tempDistVal = 20;
		reg_DamagedMonsterArray = 0;
		isMonsterHit = 0;
		if(isGunFired) begin		
			if (isMonsterDeadArray[0] == 0
					&& monster0_cethaValue == middle_cetha_value
					&& tempDistVal > monster0_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster0_distValue;
					reg_DamagedMonsterArray[0] = 1;
			end
			if (isMonsterDeadArray[1] == 0
					&& monster1_cethaValue == middle_cetha_value
					&& tempDistVal > monster1_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster1_distValue;
					reg_DamagedMonsterArray[1] = 1;
			end
			if (isMonsterDeadArray[2] == 0
					&& monster2_cethaValue == middle_cetha_value
					&& tempDistVal > monster2_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster2_distValue;
					reg_DamagedMonsterArray[2] = 1;
			end
			if (isMonsterDeadArray[3] == 0
					&& monster3_cethaValue == middle_cetha_value
					&& tempDistVal > monster3_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster3_distValue;
					reg_DamagedMonsterArray[3] = 1;
			end
			if (isMonsterDeadArray[4] == 0
					&& monster4_cethaValue == middle_cetha_value
					&& tempDistVal > monster4_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster4_distValue;
					reg_DamagedMonsterArray[4] = 1;
			end
			if (isMonsterDeadArray[5] == 0
					&& monster5_cethaValue == middle_cetha_value
					&& tempDistVal > monster5_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster5_distValue;
					reg_DamagedMonsterArray[5] = 1;
			end
			if (isMonsterDeadArray[6] == 0
					&& monster6_cethaValue == middle_cetha_value
					&& tempDistVal > monster6_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster6_distValue;
					reg_DamagedMonsterArray[6] = 1;
			end
			if (isMonsterDeadArray[7] == 0
					&& monster7_cethaValue == middle_cetha_value
					&& tempDistVal > monster7_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster7_distValue;
					reg_DamagedMonsterArray[7] = 1;
			end
			if (isMonsterDeadArray[8] == 0
					&& monster8_cethaValue == middle_cetha_value
					&& tempDistVal > monster8_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster8_distValue;
					reg_DamagedMonsterArray[8] = 1;
			end
			if (isMonsterDeadArray[9] == 0
					&& monster9_cethaValue == middle_cetha_value
					&& tempDistVal > monster9_distValue
			)begin
					reg_DamagedMonsterArray = 0;
					tempDistVal = monster9_distValue;
					reg_DamagedMonsterArray[9] = 1;
			end
			
			// 피격된된 몬스터가 있다면 몬스터 피격신호를 보낸다
			if(reg_DamagedMonsterArray != 0)
				isMonsterHit = 1;
		end
		
		//몬스터 리젠 시간이 되었을때 경우 죽은 몬스터중 하나를 살린다
		reg_regenedMonsterArray = 0;
		isRegenMonsterFouned = 0;
		if(isMonsterRegen)begin
			for(i = 0; i< MAX_monster_number ; i = i + 1) begin
				if (isMonsterDeadArray[i] == 1 && isRegenMonsterFouned == 0) begin
					reg_regenedMonsterArray[i] = 1;
					isRegenMonsterFouned = 1;
				end
			end
		end
		
		//monster가 공격할 수 있는 타이밍 일때 
		//플레이어와 거리가 0인 몬스터들의 수많큼 플레이어는 데미지를 입는다
		isPlayerDamaged = 0;
		if (delayCount == hitDelay) begin
			delayCount = 0;
			totalMonsterDamageToPlayer = 0;
			for(i = 0; i < MAX_monster_number; i = i + 1) begin
				if(isMonsterNHitPlayer[i]) begin
					totalMonsterDamageToPlayer = totalMonsterDamageToPlayer + monster_ap;
					isPlayerDamaged = 1;
				end
			end
		end	
		
		//화면에 출력되는 monster의 정보를 찾는다
		//각 화면에 출력되는 몬스터는 가장 가까운 몬스터의 정보를 선택한다
		//아래의 코드는 다음과같은 python3 로 생성한 코드이다 
		// s = """if ( monster%d_cethaValue == %d
				// && isMonsterDeadArray[%d] == 0
				// && window%d_Monster_distValue > monster%d_distValue)
				// window%d_Monster_distValue = monster%d_distValue;\n"""
		// for j in range(7):
		// 	for i in range(10):
		// 		print(s%(i,j, i,  j,i, j,i))
		window0_Monster_distValue = 20;
		window1_Monster_distValue = 20;
		window2_Monster_distValue = 20;
		window3_Monster_distValue = 20;
		window4_Monster_distValue = 20;
		window5_Monster_distValue = 20;
		window6_Monster_distValue = 20;
		//route to windowN_Monster_distValue
		if(clk) begin	
			if ( monster0_cethaValue == 0
					&& isMonsterDeadArray[0] == 0
					&& window0_Monster_distValue > monster0_distValue)
					window0_Monster_distValue = monster0_distValue;

			if ( monster1_cethaValue == 0
					&& isMonsterDeadArray[1] == 0
					&& window0_Monster_distValue > monster1_distValue)
					window0_Monster_distValue = monster1_distValue;

			if ( monster2_cethaValue == 0
					&& isMonsterDeadArray[2] == 0
					&& window0_Monster_distValue > monster2_distValue)
					window0_Monster_distValue = monster2_distValue;

			if ( monster3_cethaValue == 0
					&& isMonsterDeadArray[3] == 0
					&& window0_Monster_distValue > monster3_distValue)
					window0_Monster_distValue = monster3_distValue;

			if ( monster4_cethaValue == 0
					&& isMonsterDeadArray[4] == 0
					&& window0_Monster_distValue > monster4_distValue)
					window0_Monster_distValue = monster4_distValue;

			if ( monster5_cethaValue == 0
					&& isMonsterDeadArray[5] == 0
					&& window0_Monster_distValue > monster5_distValue)
					window0_Monster_distValue = monster5_distValue;

			if ( monster6_cethaValue == 0
					&& isMonsterDeadArray[6] == 0
					&& window0_Monster_distValue > monster6_distValue)
					window0_Monster_distValue = monster6_distValue;

			if ( monster7_cethaValue == 0
					&& isMonsterDeadArray[7] == 0
					&& window0_Monster_distValue > monster7_distValue)
					window0_Monster_distValue = monster7_distValue;

			if ( monster8_cethaValue == 0
					&& isMonsterDeadArray[8] == 0
					&& window0_Monster_distValue > monster8_distValue)
					window0_Monster_distValue = monster8_distValue;

			if ( monster9_cethaValue == 0
					&& isMonsterDeadArray[9] == 0
					&& window0_Monster_distValue > monster9_distValue)
					window0_Monster_distValue = monster9_distValue;

			if ( monster0_cethaValue == 1
					&& isMonsterDeadArray[0] == 0
					&& window1_Monster_distValue > monster0_distValue)
					window1_Monster_distValue = monster0_distValue;

			if ( monster1_cethaValue == 1
					&& isMonsterDeadArray[1] == 0
					&& window1_Monster_distValue > monster1_distValue)
					window1_Monster_distValue = monster1_distValue;

			if ( monster2_cethaValue == 1
					&& isMonsterDeadArray[2] == 0
					&& window1_Monster_distValue > monster2_distValue)
					window1_Monster_distValue = monster2_distValue;

			if ( monster3_cethaValue == 1
					&& isMonsterDeadArray[3] == 0
					&& window1_Monster_distValue > monster3_distValue)
					window1_Monster_distValue = monster3_distValue;

			if ( monster4_cethaValue == 1
					&& isMonsterDeadArray[4] == 0
					&& window1_Monster_distValue > monster4_distValue)
					window1_Monster_distValue = monster4_distValue;

			if ( monster5_cethaValue == 1
					&& isMonsterDeadArray[5] == 0
					&& window1_Monster_distValue > monster5_distValue)
					window1_Monster_distValue = monster5_distValue;

			if ( monster6_cethaValue == 1
					&& isMonsterDeadArray[6] == 0
					&& window1_Monster_distValue > monster6_distValue)
					window1_Monster_distValue = monster6_distValue;

			if ( monster7_cethaValue == 1
					&& isMonsterDeadArray[7] == 0
					&& window1_Monster_distValue > monster7_distValue)
					window1_Monster_distValue = monster7_distValue;

			if ( monster8_cethaValue == 1
					&& isMonsterDeadArray[8] == 0
					&& window1_Monster_distValue > monster8_distValue)
					window1_Monster_distValue = monster8_distValue;

			if ( monster9_cethaValue == 1
					&& isMonsterDeadArray[9] == 0
					&& window1_Monster_distValue > monster9_distValue)
					window1_Monster_distValue = monster9_distValue;

			if ( monster0_cethaValue == 2
					&& isMonsterDeadArray[0] == 0
					&& window2_Monster_distValue > monster0_distValue)
					window2_Monster_distValue = monster0_distValue;

			if ( monster1_cethaValue == 2
					&& isMonsterDeadArray[1] == 0
					&& window2_Monster_distValue > monster1_distValue)
					window2_Monster_distValue = monster1_distValue;

			if ( monster2_cethaValue == 2
					&& isMonsterDeadArray[2] == 0
					&& window2_Monster_distValue > monster2_distValue)
					window2_Monster_distValue = monster2_distValue;

			if ( monster3_cethaValue == 2
					&& isMonsterDeadArray[3] == 0
					&& window2_Monster_distValue > monster3_distValue)
					window2_Monster_distValue = monster3_distValue;

			if ( monster4_cethaValue == 2
					&& isMonsterDeadArray[4] == 0
					&& window2_Monster_distValue > monster4_distValue)
					window2_Monster_distValue = monster4_distValue;

			if ( monster5_cethaValue == 2
					&& isMonsterDeadArray[5] == 0
					&& window2_Monster_distValue > monster5_distValue)
					window2_Monster_distValue = monster5_distValue;

			if ( monster6_cethaValue == 2
					&& isMonsterDeadArray[6] == 0
					&& window2_Monster_distValue > monster6_distValue)
					window2_Monster_distValue = monster6_distValue;

			if ( monster7_cethaValue == 2
					&& isMonsterDeadArray[7] == 0
					&& window2_Monster_distValue > monster7_distValue)
					window2_Monster_distValue = monster7_distValue;

			if ( monster8_cethaValue == 2
					&& isMonsterDeadArray[8] == 0
					&& window2_Monster_distValue > monster8_distValue)
					window2_Monster_distValue = monster8_distValue;

			if ( monster9_cethaValue == 2
					&& isMonsterDeadArray[9] == 0
					&& window2_Monster_distValue > monster9_distValue)
					window2_Monster_distValue = monster9_distValue;

			if ( monster0_cethaValue == 3
					&& isMonsterDeadArray[0] == 0
					&& window3_Monster_distValue > monster0_distValue)
					window3_Monster_distValue = monster0_distValue;

			if ( monster1_cethaValue == 3
					&& isMonsterDeadArray[1] == 0
					&& window3_Monster_distValue > monster1_distValue)
					window3_Monster_distValue = monster1_distValue;

			if ( monster2_cethaValue == 3
					&& isMonsterDeadArray[2] == 0
					&& window3_Monster_distValue > monster2_distValue)
					window3_Monster_distValue = monster2_distValue;

			if ( monster3_cethaValue == 3
					&& isMonsterDeadArray[3] == 0
					&& window3_Monster_distValue > monster3_distValue)
					window3_Monster_distValue = monster3_distValue;

			if ( monster4_cethaValue == 3
					&& isMonsterDeadArray[4] == 0
					&& window3_Monster_distValue > monster4_distValue)
					window3_Monster_distValue = monster4_distValue;

			if ( monster5_cethaValue == 3
					&& isMonsterDeadArray[5] == 0
					&& window3_Monster_distValue > monster5_distValue)
					window3_Monster_distValue = monster5_distValue;

			if ( monster6_cethaValue == 3
					&& isMonsterDeadArray[6] == 0
					&& window3_Monster_distValue > monster6_distValue)
					window3_Monster_distValue = monster6_distValue;

			if ( monster7_cethaValue == 3
					&& isMonsterDeadArray[7] == 0
					&& window3_Monster_distValue > monster7_distValue)
					window3_Monster_distValue = monster7_distValue;

			if ( monster8_cethaValue == 3
					&& isMonsterDeadArray[8] == 0
					&& window3_Monster_distValue > monster8_distValue)
					window3_Monster_distValue = monster8_distValue;

			if ( monster9_cethaValue == 3
					&& isMonsterDeadArray[9] == 0
					&& window3_Monster_distValue > monster9_distValue)
					window3_Monster_distValue = monster9_distValue;

			if ( monster0_cethaValue == 4
					&& isMonsterDeadArray[0] == 0
					&& window4_Monster_distValue > monster0_distValue)
					window4_Monster_distValue = monster0_distValue;

			if ( monster1_cethaValue == 4
					&& isMonsterDeadArray[1] == 0
					&& window4_Monster_distValue > monster1_distValue)
					window4_Monster_distValue = monster1_distValue;

			if ( monster2_cethaValue == 4
					&& isMonsterDeadArray[2] == 0
					&& window4_Monster_distValue > monster2_distValue)
					window4_Monster_distValue = monster2_distValue;

			if ( monster3_cethaValue == 4
					&& isMonsterDeadArray[3] == 0
					&& window4_Monster_distValue > monster3_distValue)
					window4_Monster_distValue = monster3_distValue;

			if ( monster4_cethaValue == 4
					&& isMonsterDeadArray[4] == 0
					&& window4_Monster_distValue > monster4_distValue)
					window4_Monster_distValue = monster4_distValue;

			if ( monster5_cethaValue == 4
					&& isMonsterDeadArray[5] == 0
					&& window4_Monster_distValue > monster5_distValue)
					window4_Monster_distValue = monster5_distValue;

			if ( monster6_cethaValue == 4
					&& isMonsterDeadArray[6] == 0
					&& window4_Monster_distValue > monster6_distValue)
					window4_Monster_distValue = monster6_distValue;

			if ( monster7_cethaValue == 4
					&& isMonsterDeadArray[7] == 0
					&& window4_Monster_distValue > monster7_distValue)
					window4_Monster_distValue = monster7_distValue;

			if ( monster8_cethaValue == 4
					&& isMonsterDeadArray[8] == 0
					&& window4_Monster_distValue > monster8_distValue)
					window4_Monster_distValue = monster8_distValue;

			if ( monster9_cethaValue == 4
					&& isMonsterDeadArray[9] == 0
					&& window4_Monster_distValue > monster9_distValue)
					window4_Monster_distValue = monster9_distValue;

			if ( monster0_cethaValue == 5
					&& isMonsterDeadArray[0] == 0
					&& window5_Monster_distValue > monster0_distValue)
					window5_Monster_distValue = monster0_distValue;

			if ( monster1_cethaValue == 5
					&& isMonsterDeadArray[1] == 0
					&& window5_Monster_distValue > monster1_distValue)
					window5_Monster_distValue = monster1_distValue;

			if ( monster2_cethaValue == 5
					&& isMonsterDeadArray[2] == 0
					&& window5_Monster_distValue > monster2_distValue)
					window5_Monster_distValue = monster2_distValue;

			if ( monster3_cethaValue == 5
					&& isMonsterDeadArray[3] == 0
					&& window5_Monster_distValue > monster3_distValue)
					window5_Monster_distValue = monster3_distValue;

			if ( monster4_cethaValue == 5
					&& isMonsterDeadArray[4] == 0
					&& window5_Monster_distValue > monster4_distValue)
					window5_Monster_distValue = monster4_distValue;

			if ( monster5_cethaValue == 5
					&& isMonsterDeadArray[5] == 0
					&& window5_Monster_distValue > monster5_distValue)
					window5_Monster_distValue = monster5_distValue;

			if ( monster6_cethaValue == 5
					&& isMonsterDeadArray[6] == 0
					&& window5_Monster_distValue > monster6_distValue)
					window5_Monster_distValue = monster6_distValue;

			if ( monster7_cethaValue == 5
					&& isMonsterDeadArray[7] == 0
					&& window5_Monster_distValue > monster7_distValue)
					window5_Monster_distValue = monster7_distValue;

			if ( monster8_cethaValue == 5
					&& isMonsterDeadArray[8] == 0
					&& window5_Monster_distValue > monster8_distValue)
					window5_Monster_distValue = monster8_distValue;

			if ( monster9_cethaValue == 5
					&& isMonsterDeadArray[9] == 0
					&& window5_Monster_distValue > monster9_distValue)
					window5_Monster_distValue = monster9_distValue;

			if ( monster0_cethaValue == 6
					&& isMonsterDeadArray[0] == 0
					&& window6_Monster_distValue > monster0_distValue)
					window6_Monster_distValue = monster0_distValue;

			if ( monster1_cethaValue == 6
					&& isMonsterDeadArray[1] == 0
					&& window6_Monster_distValue > monster1_distValue)
					window6_Monster_distValue = monster1_distValue;

			if ( monster2_cethaValue == 6
					&& isMonsterDeadArray[2] == 0
					&& window6_Monster_distValue > monster2_distValue)
					window6_Monster_distValue = monster2_distValue;

			if ( monster3_cethaValue == 6
					&& isMonsterDeadArray[3] == 0
					&& window6_Monster_distValue > monster3_distValue)
					window6_Monster_distValue = monster3_distValue;

			if ( monster4_cethaValue == 6
					&& isMonsterDeadArray[4] == 0
					&& window6_Monster_distValue > monster4_distValue)
					window6_Monster_distValue = monster4_distValue;

			if ( monster5_cethaValue == 6
					&& isMonsterDeadArray[5] == 0
					&& window6_Monster_distValue > monster5_distValue)
					window6_Monster_distValue = monster5_distValue;

			if ( monster6_cethaValue == 6
					&& isMonsterDeadArray[6] == 0
					&& window6_Monster_distValue > monster6_distValue)
					window6_Monster_distValue = monster6_distValue;

			if ( monster7_cethaValue == 6
					&& isMonsterDeadArray[7] == 0
					&& window6_Monster_distValue > monster7_distValue)
					window6_Monster_distValue = monster7_distValue;

			if ( monster8_cethaValue == 6
					&& isMonsterDeadArray[8] == 0
					&& window6_Monster_distValue > monster8_distValue)
					window6_Monster_distValue = monster8_distValue;

			if ( monster9_cethaValue == 6
					&& isMonsterDeadArray[9] == 0
					&& window6_Monster_distValue > monster9_distValue)
					window6_Monster_distValue = monster9_distValue;

		end
	
	end
	

endmodule

