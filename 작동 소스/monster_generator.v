module monster_generator(
	input wire clk,
	input wire reset,
	output reg isMonsterRegen,
	output reg [4:0] monster_generator_index
);

	wire wire_tc_Hz1;
	
	//for real time
	parameter mod_1hz = 50000000;
	//for simulation
	//parameter mod_1hz = 4;
	wire [31:0] random_seed;
	
	counter #( mod_1hz ) module_Hz1_counter (
		.qout		(random_seed), 
		.tc			(wire_tc_Hz1), 
		.enable		(1),
		.load		(0),
		.din		(0),
		.reset		(0),
		.clk		(clk)
	);	
	
	// make regen time
	//regen되는 시간을 처리한다
	parameter monster_regen_time = 2;
	integer timeCount;
	always @(posedge clk) begin
		if (reset) begin
			timeCount <= 0;
		end
		isMonsterRegen = 0;
		if (wire_tc_Hz1) begin
			if (timeCount == monster_regen_time) begin
				timeCount <= 0;
				isMonsterRegen = 1;
			end
			else begin
				timeCount <= timeCount + 1;
			end
		end
	end		
	
	//몬스터가 발생될 각도정보는 난수를 이용한다
	//xor shift 방식으로 난수를 생성한다
	//seed는 50Mhz tc counter의 count 값을 이용한다
	parameter mod_monsterIndex = 21;	
	integer t,x,y,z,w;
	always @(posedge clk) begin 
		if(reset) begin
			t = random_seed;
			x = random_seed;
			y = random_seed;
			z = random_seed;
			w = random_seed;
		end
		
		if ( isMonsterRegen ) begin
			t = x;
			t = t^(t << 11);
			t = t^(t >> 8);
			x = y; 
			y = z; 
			z = w;
			w = w^(w >> 19);
			w = w^t;			
			monster_generator_index = w % mod_monsterIndex;
		end	
	end
endmodule








