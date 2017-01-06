module VGA_CONTROLLER (
	CLK25, 
	reset, 
	in_r, 
	in_g, 
	in_b,
	px, 
	py, 
	vga_r, 
	vga_g, 
	vga_b, 
	hsync, 
	vsync, 
	vga_sync, 
	vga_blank, 
	vga_clk
);

	input CLK25;
	input reset;
	input [9:0] in_r, in_g, in_b;
	output reg [9:0] px, py;
	output [9:0] vga_r, vga_g, vga_b;
	output reg hsync, vsync;
	output vga_sync, vga_blank;
	output vga_clk;

	reg video_on;
	reg [9:0] hcount, vcount;

	//출력할 픽셀의 열좌표인 hcount를 갱신한다
	always @(posedge CLK25 or posedge reset) begin
		if(reset) hcount <= 0;
		else begin 
			if(hcount == 799) 
				hcount <= 0;
			else 
				hcount <= hcount + 1;
		end
	end

	//VGA 동기화를 위한 hsync값을 갱신한다 
	always @(posedge CLK25) begin
		if( (hcount >= 659) & (hcount <= 755) ) 
			hsync <= 0;
		else 
			hsync <= 1;
	end

	//출력할 픽셀의 행좌표인 vcount를 갱신한다
	//이전 행의 모든 픽셀이 출력이 완료 되었다면 다음 행으로 넘어간다
	always @(posedge CLK25 or posedge reset) begin
		if (reset)
			vcount <= 0;
		else if (hcount == 799) begin
			if (vcount == 524) 
				vcount <= 0;
			else 
				vcount <= vcount + 1;
		end
	end

	//VGA 동기화를 위한 vsync값을 갱신한다 
	always @(posedge CLK25) begin
		if( (vcount >= 493) & (vcount<= 494) )
			vsync <= 0;
		else 
		vsync <= 1;
	end
	
	//video on h
	//VGA의 각행과 열의 픽셀을 표시하는 타이밍에만 화면을 킨다
	always @(posedge CLK25) begin
		video_on <= (hcount <= 639) && (vcount <= 479);
	end
	
	//화면에 출력할 RGB값을 가져오기위해 필요한 픽셀 좌표를 출력한다
	always @(posedge CLK25) begin
		px <= hcount;
		py <= vcount;
	end

	//
	assign vga_clk = ~CLK25;
	assign vga_blank = hsync & vsync;
	assign vga_sync = 1'b0;
	
	//VGA의 화면이 켜저있을떄만 RGB값이 출력되도록 만든다
	assign vga_r = video_on ? in_r : 10'h000;
	assign vga_g = video_on ? in_g : 10'h000;
	assign vga_b = video_on ? in_b : 10'h000;
	
endmodule


