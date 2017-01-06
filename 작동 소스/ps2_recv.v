module ps2_recv(
	input wire clk, 					// 50Mhz clk
	input wire reset,					// reset signal
	input wire ps2d,					// ps2 data
	input wire ps2c,               		// ps2 clock 
	output wire [7:0] scan_code,        // scan_code 키보드로 부터 받은 스캔코드 값
	output wire scan_code_ready         // 키보드로부터 입력을 받음을 알리는 sinal
);
	
    localparam  BREAK_CODE   	= 8'hf0;// break code

    localparam  KEY_DOWN		= 0, 	// scan_code가 입력 받았을떄 
                KEY_UP      	= 1; 	// 이전의 scan_code가 break code일경우 다음에 들어오는 scan_code는 무시한다
               
    reg state;							// 상태 
	reg	next_state; 					// FSM state register and next state logic
    wire [7:0] scan_out;				
    reg reg_isScanCodeRx;				
    wire wire_isScanCodeRx;				
    
    ps2_rx ps2_rx_state_unit (
		.clk(clk), 
		.reset(reset), 
		.rx_state_en(1), 
		.ps2d(ps2d), 
		.ps2c(ps2c), 
		.rx_state_done_tick(wire_isScanCodeRx),
		.rx_state_data(scan_out)
	);
	
	// FSM의 상태를 갱신한다
    always @(posedge clk, posedge reset)
        if (reset) begin
			state      <= KEY_DOWN;
		end
        else begin    
			state      <= next_state;
		end
			
    //FSM의 다음 상태를 결정한다
    always @* begin       
        // defaults
        reg_isScanCodeRx   	= 1'b0;
        next_state      	= state;
       
        case(state)	
		KEY_DOWN: begin  
			//키보드의 scan code가 왔을떄 
			if(wire_isScanCodeRx) begin
				//입력이 들어왔다면 일단 code를 받았다고 처리한다
				reg_isScanCodeRx = 1'b1;                                                         
				// beack code라면 키를 뗸것이므로 다음 상태는 KEY_UP로 변경한다
				if (scan_out == BREAK_CODE) begin                                                      
					next_state = KEY_UP;                                                    
				end
			end	
		end
		KEY_UP: begin
			// break code 다음에 오는 스캔코드는 무시하고 KEY_DOWN 상태로 돌아간다 
			if(wire_isScanCodeRx)  begin                                                                
				next_state = KEY_DOWN;                                                        
			end
		end    
        endcase
    end
			
    //scan code를 받았음을 처리한다
    assign scan_code_ready = reg_isScanCodeRx;
	
    // route scan code data out
    assign scan_code = scan_out;
	
endmodule


module ps2_rx(
	input wire clk, 
	input wire reset, 
	input wire ps2d, 
	input wire ps2c, 
	input wire rx_state_en,    			// receive enable input
	output reg rx_state_done_tick,      // ps2 수신 완료 신호
	output wire [7:0] rx_state_data     // data received 
);

	// FSM 상태 
	localparam 		idle_state = 0, //대기상태
					rx_state   = 1; //수신중 상태
		
	reg state;
	reg	next_state;          		// FSMD state register
	
	reg [7:0] filter_reg;           // 필터값을 저장할 reg
	wire [7:0] filter_next;         // 
	reg f_val_reg;                  // falling_edge detection을 위한 reg
	wire f_val_next;                // 
	reg [3:0] bitCount;				// 입력받을 비트를 셀 count reg
	reg	[3:0] next_bitCount;        // 
	reg [10:0] received_data;		// 전송받은 데이터 저장 reg
	reg [10:0] next_received_data;  // register to shift in rx_state data
	wire falling_edge;              // ps/2 수신을 위한 falling edge 신호
	
	// 필터값을 클럭마다 다음상태로 갱신한다
	always @(posedge clk, posedge reset) begin
		if (reset) begin
			filter_reg <= 0;
			f_val_reg  <= 0;
		end
		else begin
			filter_reg <= filter_next;
			f_val_reg  <= f_val_next;
		end
	end
	
	// 다음 필터값을 받기위해 오른쪽 시프트를 한다 
	assign filter_next = {ps2c, filter_reg[7:1]};
	
	// clk 필터를 위해 필터값이 모두 0이거나 1일때를 검사한다
	assign f_val_next = (filter_reg == 8'b11111111) ? 1 :
						(filter_reg == 8'b00000000) ? 0 :
						f_val_reg;
	
	// 동기화된 ps2 clk신호가 0,1이 반복되는 bouncing을 방지하기위해 falling edge detection을 사용한다 
	assign falling_edge = f_val_reg & ~f_val_next;
	
	// bitCount, received_data를 클럭마다 다음상태로 갱신한다
	always @(posedge clk, posedge reset)begin
		if (reset) begin
			state <= idle_state;
			bitCount <= 0;
			received_data <= 0;
		end
		else begin
			state <= next_state;
			bitCount <= next_bitCount;
			received_data <= next_received_data;
		end
	end
	
	// FSMD next state logic
	always @* begin		
		// defaults
		next_state = state;
		rx_state_done_tick = 1'b0;
		next_bitCount = bitCount;
		next_received_data = received_data;
		
		case (state)	
		//대기상태
		idle_state: begin
			if (falling_edge && rx_state_en) begin  // 스타트 비트를 입력받았을떄 
				next_bitCount = 10;            		// 입력받을 비트 카운터를 10으로 설정, 남은 수신할 비트는 총10개이다
				next_state = rx_state;              // rx_state로 넘어간다
			end
		end
		//입력을 받는중일떄
		rx_state: begin                             // shift in 8 data, 1 parity, and 1 stop bit
			if (falling_edge) begin               	// falling edge로 데이터를 받았을떄
				next_received_data = {ps2d, received_data[10:1]}; 	//받은 데이터를 쉬프트시켜 추가한다
				next_bitCount = bitCount - 1;       // 비트 카운터를 감소시킨다
			end		
			if (bitCount == 0) begin            	//모든 비트를 받았으면
				rx_state_done_tick = 1'b1;         	//비트를 받음신호를 발생하고 
				next_state = idle_state;          	// idle_state로 돌아간다
			end
		end
		endcase		
	end
		
	assign rx_state_data = received_data[8:1]; // output data bits 
endmodule



















