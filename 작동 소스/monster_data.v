module monster_data(
//module monster_data(
	//input 
	input wire clk,
	input wire reset,
	
	input wire playerMoveLeft,
	input wire playerMoveRight,
	input wire playerMoveForward,
	input wire playerMoveBackward,
	input wire monster_move,
	
	input wire isDamaged,
	input wire [9:0] DamagedValue,
	
	input wire isMonsterRegen,
	input wire [4:0] regenCethaValue,
	input wire [4:0] regenDistValue,
	// output 
	output wire [9:0] monster_lifePoint,
	output wire isDead,
	output wire [4:0] monster_cethaValue,
	output wire [4:0] monster_distValue
);
	
	//parameter defalt_monster_lifePoint;
	lifePoint_data #( .resetLifePoint(0), .maxLifePoint(10) ) module_monster_lifePoint (
		.clk(clk),
		.reset(reset),
		.isRegen(isMonsterRegen),
		.isDamaged(isDamaged),
		.damagedValue(DamagedValue),
		.lifePoint(monster_lifePoint),
		.isDead(isDead)
	);

	reg reg_isMinus_cethaValue;
	wire wire_isMinus_cethaValue = reg_isMinus_cethaValue;
	reg reg_isPlus_cethaValue;
	wire wire_isPlus_cethaValue = reg_isPlus_cethaValue;
	reg reg_isMinus_distValue;
	wire wire_isMinus_distValue = reg_isMinus_distValue;
	reg reg_isPlus_distValue;
	wire wire_isPlus_distValue = reg_isPlus_distValue;
	
	location_data module_location_data(
		.clk(clk),
		.reset(reset),		
		.isSet_cethaValue(isMonsterRegen),
		.set_cethaValue(regenCethaValue),
		
		.isSet_distValue(isMonsterRegen),
		.set_distValue(regenDistValue),	
		
		.isMinus_cethaValue(wire_isMinus_cethaValue),
		.isPlus_cethaValue(wire_isPlus_cethaValue),
		
		.isMinus_distValue(reg_isMinus_distValue),
		.isPlus_distValue(wire_isPlus_distValue),
		
		.cethaValue(monster_cethaValue),
		.distValue(monster_distValue)
	);

	wire pulse_playerMoveLeft;
	pulse_maker module_pulse_maker_playerMoveLeft(
		.clk(clk),
		.reset(reset),
		.inputSignal(playerMoveLeft),
		.outputPulse(pulse_playerMoveLeft)
	);
	
	wire pulse_playerMoveRight;
	pulse_maker module_pulse_maker_playerMoveRight(
		.clk(clk),
		.reset(reset),
		.inputSignal(playerMoveRight),
		.outputPulse(pulse_playerMoveRight)
	);
	
	wire pulse_playerMoveForward;
	pulse_maker module_pulse_maker_playerMoveForward(
		.clk(clk),
		.reset(reset),
		.inputSignal(playerMoveForward),
		.outputPulse(pulse_playerMoveForward)
	);
	
	wire pulse_playerMoveBackward;
	pulse_maker module_pulse_maker_playerMoveBackward(
		.clk(clk),
		.reset(reset),
		.inputSignal(playerMoveBackward),
		.outputPulse(pulse_playerMoveBackward)
	);
	
	
	always @(posedge clk) begin
		reg_isMinus_cethaValue = 0;
		reg_isPlus_cethaValue = 0;
		reg_isMinus_distValue = 0;
		reg_isPlus_distValue = 0;
		
		//몬스터가 살아있을 때만 위치정보가 갱신되어야한다
		if(isDead == 0) begin
			//플레이어가 좌우로 회전시 몬스터의 cethaValue를 변경하도록 신호를 보낸다
			if(pulse_playerMoveLeft)begin
				reg_isMinus_cethaValue = 1;
			end		
			if(pulse_playerMoveRight) begin
				reg_isPlus_cethaValue = 1;
			end
			
			//플레이어가 앞뒤로 이동할경우 몬스터의 거리정보를 갱신한다
			if(pulse_playerMoveForward) begin
				if(monster_cethaValue >=0 && monster_cethaValue <= 6) begin
					reg_isPlus_distValue = 1;
				end
				else if (monster_cethaValue >=11 && monster_cethaValue<= 16)begin
					reg_isMinus_distValue = 1;
				end
			end
			if(pulse_playerMoveBackward) begin
				if(monster_cethaValue >= 0 && monster_cethaValue <= 6) begin
					reg_isMinus_distValue = 1;
				end
				else if (monster_cethaValue >= 11 && monster_cethaValue<= 16)begin
					reg_isPlus_distValue = 1;
				end
			end
			
			//몬스터가 움직일때는 플레이어로부터의 거리가 줄어든다
			if(monster_move) begin
				reg_isMinus_distValue =1;		
			end
		end
	end

endmodule 




