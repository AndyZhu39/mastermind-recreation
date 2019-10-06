module lbtimer(clk, pulse, resetn, next_turn);
	input next_turn; // next turn signal can come from control after drawing pegs
	input resetn;
	input clk;
	wire second_pulse;
	output pulse;
	reg[25:0] counter;
	reg[6:0] counter2;
	
	assign second_pulse = (counter == 0) ? 1: 0;
	
	assign pulse = (counter2 == 60) ? 1: 0;
	
	// not sure if it's supposed to be 50m or 49,999,999
	always@(posedge clk)
	begin
		if(!resetn || next_turn)
			counter <= 26'b10111110101111000001111111;
		if(counter == 0)
			counter <= 26'b10111110101111000001111111;
		counter <= counter - 1;
	end
	
	always@(posedge clk)
	begin
		if(!resetn || next_turn)
			counter2 <= 6'd0;
		if(pulse == 1)
			counter2 <= counter + 1;
	end
endmodule
