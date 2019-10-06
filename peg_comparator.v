module peg_comparator(ans_1, ans_2, ans_3, ans_4, ans_5, guess_1, guess_2, guess_3, guess_4, guess_5, cor_p, cor_c, win);
	input [2:0] ans_1;
	input [2:0] ans_2;
	input [2:0] ans_3;
	input [2:0] ans_4;
	input [2:0] ans_5;
	input [2:0] guess_1;
	input [2:0] guess_2;
	input [2:0] guess_3;
	input [2:0] guess_4;
	input [2:0] guess_5;
	output [2:0] cor_p;
	output [2:0] cor_c;
	output win;
	
	// individual connections
	wire [24:0] connections;
	
	reg [4:0] cnotp;
	
	assign connections[0] = guess_1 == ans_1;
	assign connections[1] = guess_1 == ans_2;
	assign connections[2] = guess_1 == ans_3;
	assign connections[3] = guess_1 == ans_4;
	assign connections[4] = guess_1 == ans_5;
	assign connections[5] = guess_2 == ans_1;
	assign connections[6] = guess_2 == ans_2;
	assign connections[7] = guess_2 == ans_3;
	assign connections[8] = guess_2 == ans_4;
	assign connections[9] = guess_2 == ans_5;
	assign connections[10] = guess_3 == ans_1;
	assign connections[11] = guess_3 == ans_2;
	assign connections[12] = guess_3 == ans_3;
	assign connections[13] = guess_3 == ans_4;
	assign connections[14] = guess_3 == ans_5;
	assign connections[15] = guess_4 == ans_1;
	assign connections[16] = guess_4 == ans_2;
	assign connections[17] = guess_4 == ans_3;
	assign connections[18] = guess_4 == ans_4;
	assign connections[19] = guess_4 == ans_5;
	assign connections[20] = guess_5 == ans_1;
	assign connections[21] = guess_5 == ans_2;
	assign connections[22] = guess_5 == ans_3;
	assign connections[23] = guess_5 == ans_4;
	assign connections[24] = guess_5 == ans_5;
	

	// setting output signals
	assign cor_p = connections[0] + connections[6] + connections[12] + connections[18] + connections[24];
	assign cor_c = cnotp[0] + cnotp[1] + cnotp[2] + cnotp[3] + cnotp[4];
	
	always@(*)
	begin
	if (connections[0] == 1)
		cnotp[0] = 0;
	else
		cnotp[0] = (connections[1] | connections[2] | connections[3] | connections[4]);
	
	if (connections[6] == 1)
		cnotp[1] = 0;
	else
		cnotp[1] = (connections[5] | connections[7] | connections[8] | connections[9]);
		
	if (connections[12] == 1)
		cnotp[2] = 0;
	else
		cnotp[2] = (connections[10] | connections[11] | connections[13] | connections[14]);
		
	if (connections[18] == 1)
		cnotp[3] = 0;
	else
		cnotp[3] = (connections[15] | connections[16] | connections[17] | connections[19]);
		
	if (connections[24] == 1)
		cnotp[4] = 0;
	else
		cnotp[4] = (connections[20] | connections[21] | connections[22] | connections[23]);
	end
	
	
	assign win = cor_p == 5;
	
endmodule
	
			/*			(connections[1] | connections[2] | connections[3] | connections[4]) + 
						(connections[5] | connections[7] | connections[8] | connections[9]) + 
						(connections[10] | connections[11] | connections[13] | connections[14]) + 
						(connections[15] | connections[16] | connections[17] | connections[19]) +
						(connections[20] |  connections[21] |  connections[22] |  connections[23]);*/
	
	
