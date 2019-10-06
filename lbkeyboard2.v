module lbkeyboard2(clk, resetn, PS2_CLK, PS2_DAT, kb_out);
	input clk;
	input resetn;
	inout PS2_CLK;
	inout PS2_DAT;
	output reg [4:0] kb_out;
	
	// wires that represent the output signals of the keyboard ( 1 or 0)
	wire one_p, two_p, three_p, four_p, five_p, six_p, seven_p, eight_p, nine_p, zero_p;
	
	
	// instantiating ps2_keyboard_controller
	keyboard_tracker #(.PULSE_OR_HOLD(0)) kbc ( .clock(clk), 
											.reset(resetn), 
											.PS2_CLK(PS2_CLK), 
											.PS2_DAT(PS2_DAT),
											.one(one_p),
											.two(two_p),
											.three(three_p),
											.four(four_p),
											.five(five_p),
											.six(six_p),
											.seven(seven_p),
											.eight(eight_p),
											.nine(nine_p),
											.zero(zero_p)
											);
	
	
	// mux for keyboard out signals
	always @(*)
	begin
		if(one_p == 1)
			kb_out = 5'b01000;
		else if(two_p == 1)
			kb_out = 5'b01001;
		else if(three_p == 1)
			kb_out = 5'b01010;
		else if(four_p == 1)
			kb_out = 5'b01011;
		else if(five_p == 1)
			kb_out = 5'b01100;
		else if(six_p == 1)
			kb_out = 5'b01101;
		else if(seven_p == 1)
			kb_out = 5'b01110;
		else if(eight_p == 1)
			kb_out = 5'b01111;
		else if(zero_p == 1)
			kb_out = 5'b10000;
		else
			kb_out = 5'b00000;
	end
endmodule
