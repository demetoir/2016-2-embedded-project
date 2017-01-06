module location_data(
	input wire clk,
	input wire reset,	
	input wire isSet_cethaValue,
	input wire [4:0] set_cethaValue,	
	input wire isSet_distValue,
	input wire [4:0] set_distValue,		
	input wire isMinus_cethaValue,
	input wire isPlus_cethaValue,	
	input wire isMinus_distValue,
	input wire isPlus_distValue,	
	output reg [4:0] cethaValue,
	output reg [4:0] distValue
);

	parameter defalt_reset_cethaValue = 0;	
	parameter defalt_reset_distValue = 10;
	parameter defalt_moduloValue = 21;
	parameter defalt_maxDistanceValue = 25;
	
	wire pulse_isSet_cethaValue;	
	pulse_maker module_pulse_maker_isSet_cethaValue( 
		.clk(clk),
		.reset(reset),
		.inputSignal(isSet_cethaValue),
		.outputPulse(pulse_isSet_cethaValue)
	);
	
	wire pulse_isSet_distValue;
	pulse_maker module_pulse_maker_isSet_distValue( 
		.clk(clk),
		.reset(reset),
		.inputSignal(isSet_distValue),
		.outputPulse(pulse_isSet_distValue)
	);
	
	wire pulse_isMinus_cethaValue;
	pulse_maker module_pulse_maker_isMinus_cethaValue( 
		.clk(clk),
		.reset(reset),
		.inputSignal(isMinus_cethaValue),
		.outputPulse(pulse_isMinus_cethaValue)
	);
	
	wire pulse_isPlus_cethaValue;
	pulse_maker module_pulse_maker_isPlus_cethaValue( 
		.clk(clk),
		.reset(reset),
		.inputSignal(isPlus_cethaValue),
		.outputPulse(pulse_isPlus_cethaValue)
	);
	
	wire pulse_isMinus_distValue;
	pulse_maker module_pulse_maker_pulse_isMinus_distValue( 
		.clk(clk),
		.reset(reset),
		.inputSignal(isMinus_distValue),
		.outputPulse(pulse_isMinus_distValue)
	);
	
	wire pulse_isPlus_distValue;
	pulse_maker module_pulse_maker_isPlus_distValue( 
		.clk(clk),
		.reset(reset),
		.inputSignal(isPlus_distValue),
		.outputPulse(pulse_isPlus_distValue)
	);
	
	
	//위치정보를 처리하는 부분
	//cethaValue 플레이어로 부터의 각도 
	//distValue 플레이어로 부터의 거리
	always @(posedge clk) begin
		if (reset) begin
			cethaValue = defalt_reset_cethaValue;
			distValue = defalt_reset_distValue;
		end
		
		if(pulse_isSet_cethaValue) begin
			cethaValue = set_cethaValue;
		end
		if(pulse_isSet_distValue) begin
			distValue = set_distValue;
		end
		
		
		//cethaValue가 변경될떄 modulo연산을 한다
		//modulo연산하는것보다는 조건문을 하는것이 좀더 적은 logic gate를 사용한다
		//각도 감소 신호 발생시
		if(pulse_isMinus_cethaValue) begin
			if (cethaValue == 0) begin
				cethaValue = defalt_moduloValue - 1;
			end
			else begin
				cethaValue = cethaValue - 1;
			end
		end
		//각도 증가 신호 발생시
		if(pulse_isPlus_cethaValue) begin
			if (cethaValue == defalt_moduloValue - 1) begin
				cethaValue = 0;
			end
			else begin
				cethaValue = cethaValue + 1;
			end
		end
		
		//distValue를 변경한다
		//오버플로우와 언더플로우를 막기위해 추가의 조건문을 사용함
		//거리 감소 신호 발생시
		if(pulse_isMinus_distValue) begin
			if (distValue > 0) begin
				distValue = distValue - 1;
			end
		end
		//거리 증가 신호발생시
		if(pulse_isPlus_distValue) begin
			if (distValue < defalt_maxDistanceValue ) begin
				distValue = distValue + 1;
			end
		end	
	end
endmodule


