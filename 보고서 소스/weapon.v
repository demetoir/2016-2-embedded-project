module weapon(
	input wire clk,				//50Mhz clk
	input wire reset,			//reset signal
	input wire isTryToFire, 	//플레이어가 총 발사에 대한 입력신호
	input wire isTryToReload, 	//플레이어가 재장전에 대한 입력신호
	output reg [4:0] leftBullet,//남은 총알수에대한 정보 신호
	output reg isFired			//총 발사에 성공에 대한 입력신호
);
	//for real time
	parameter mod_oneBullet_reloadTime = 5000000 * oneBullet_reloadTime;
	//for simulation
	//parameter mod_oneBullet_reloadTime = 5;
	
	parameter max_bullet_number		= 6;
	parameter oneBullet_reloadTime 	= 4;
	
	wire tc_oneBullet_reloadTime;
	
	wire counter_enable = isReloadCounterStart;
	counter #( mod_oneBullet_reloadTime ) module_reloadTimeCounter (
		.qout		(), 
		.tc			(tc_oneBullet_reloadTime), 
		.enable		(counter_enable),
		.load		(0),
		.din		(0),
		.reset		(pulse_isTryToReload),
		.clk		(clk)
	);		
	
	wire pulse_isTryToFire;
	pulse_maker module_pulse_maker_isTryToFire(
		.clk(clk),
		.reset(reset),
		.inputSignal(isTryToFire),
		.outputPulse(pulse_isTryToFire)
	);
	
	wire pulse_isTryToReload;
	pulse_maker module_pulse_maker_isTryToReload(
		.clk(clk),
		.reset(reset),
		.inputSignal(isTryToReload),
		.outputPulse(pulse_isTryToReload)
	);
		
	reg isReloadCounterStart;
	always @(posedge clk) begin
		//reset시 남은 총알을 처리한다
		if (reset) begin
			leftBullet = max_bullet_number;
			isReloadCounterStart = 0;
		end
		
		//총은 재장전중이 아니고 남은총알이 있을떄만 발사가 가능하다
		isFired = 0;
		if(pulse_isTryToFire && isReloadCounterStart == 0 && leftBullet > 0) begin
			leftBullet = leftBullet - 1;
			isFired = 1;
		end
		
		//재장전신호시 재장전하도록 재장전 카운터 작동을 시작한다
		if(pulse_isTryToReload) begin
			isReloadCounterStart = 1;
		end
		
		//일정 딜레이를 두고 총알이 하나씩 장전되고 장전이 끝나면 재장전 카운터를 정시킨다 
		if(tc_oneBullet_reloadTime && isReloadCounterStart) begin
			leftBullet = leftBullet + 1;
			if (leftBullet >= max_bullet_number) begin
				leftBullet = max_bullet_number;
				isReloadCounterStart = 0;
			end
		end
	end	

	endmodule






