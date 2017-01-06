module pulse_maker(
	input wire clk,
	input wire reset,
	input wire inputSignal,
	output reg outputPulse
);
	reg isSignalUp;

	//sigal이 up 되었을떄 클럭당 한번만 적용되도록 만든다
	always @(posedge clk) begin
		if(reset) begin
			outputPulse =0;
			isSignalUp = 0;
		end
		 
		outputPulse =0;
		if (inputSignal == 1 && isSignalUp == 0) begin
			isSignalUp = 1;
			outputPulse = 1;
		end
		else if (inputSignal == 0) begin
			isSignalUp = 0;
		end
	end
endmodule 