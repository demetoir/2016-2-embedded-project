module lifePoint_data (
	input wire clk,					//50Mhz clk
	input wire reset,				//reset signal
	input wire isRegen,				//regen signal
	input wire isDamaged,			//피격유무에대한 신호
	input wire [9:0] damagedValue,	//피격시 피격데미지 양
	output reg [9:0] lifePoint,		//남아있는 lifePoint
	output wire isDead				//lifePoint가 0이 되어 사망했는지에 대한 신호
);

	parameter resetLifePoint = 0;
	parameter maxLifePoint = 10;
	
	wire pulse_isDamaged;
	pulse_maker module_pulse_maker_isDamaged (
		.clk(clk),
		.reset(reset),
		.inputSignal(isDamaged),
		.outputPulse(pulse_isDamaged)
	);
	
	wire pulse_isRegen;
	pulse_maker module_pulse_maker_isRegen (
		.clk(clk),
		.reset(reset),
		.inputSignal(isRegen),
		.outputPulse(pulse_isRegen)
	);
	
	//lifePoint가 0 이면 사망한것으로 처리한다	
	assign isDead = (lifePoint == 0);
	
	//lifePoint 를 처리하는 부분
	always @(posedge clk) begin
		//reset 시 초기 체력값으로 세팅
		if(reset) begin
			lifePoint = resetLifePoint;
		end
		//데미지를 입었을때 데미지 많큼 체력이 감소한다
		if (pulse_isDamaged) begin
			//언더 플로우를 막기위해서 데미지가 더 클때는 lifePoint를 0으로 세팅한다
			if( lifePoint <= damagedValue) begin
				lifePoint = 0;
			end
			else begin
				lifePoint = lifePoint - damagedValue;
			end
		end
		//regen되었을떄 최대 lifePoint로 값을 변경한다
		if(pulse_isRegen)begin
			lifePoint = maxLifePoint;
		end		
	end
	

endmodule
