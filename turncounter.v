module turncounter(data, resetn, current_turn, clk, game_over);
	input clk;
	input resetn;
	input [1:0] data;
	output reg [3:0] current_turn;
	output reg [1:0] game_over;
	
	reg [3:0] current_state, next_state;
	
	// states
	localparam  start = 4'd0,
					turn1 = 4'd1,
					turn2 = 4'd2,
					turn3 = 4'd3,
					turn4 = 4'd4,
					turn5 = 4'd5,
					turn6 = 4'd6,
					turn7 = 4'd7,
					turn8 = 4'd8,
					turn9 = 4'd9,
					turn10 = 4'd10,
					win = 4'd11,
					lose = 4'd12;
					
	// state transitions
	// 01 means next turn, or lose on turn 10
	// 10 means win
	// 00/11 means stay
	// win/lose should stay in their respective state, because the game is over.
	always@(*)
    begin: state_table 
            case (current_state)
                turn1: begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn2;
						else
							next_state = turn1;
					 end
					 
					 turn2:begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn3;
						else
							next_state = turn2;
					 end
					 
					 turn3:begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn4;
						else
							next_state = turn3;
					 end
					 
					 turn4: begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn5;
						else
							next_state = turn4;
					 end
					 turn5: begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn6;
						else
							next_state = turn5;
					 end
                turn6:begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn7;
						else
							next_state = turn6;
					 end
					 turn7:begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn8;
						else
							next_state = turn7;
					 end
					 turn8:begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn9;
						else
							next_state = turn8;
					 end
					 turn9:begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = turn10;
						else
							next_state = turn9;
					 end
					 turn10:begin
						if (data == 2'b10)
							next_state = win;
						else if (data == 2'b01)
							next_state = lose;
						else
							next_state = turn10;
					 end
					 lose: next_state = lose;
					 win: next_state = win;
				default:     next_state = start;
        endcase
    end // state_table
	 
	 
	 // Output logic aka all of our datapath control signals
	 // hopefully current_turn saves and we can use that
	 // game_over is a signal for if the game is done or not
	 // 0 means not done, 1 means loss, 2 means win
	 // win/lose shouldn't transition out of their state without resetn, constantly outputting the game is over
    always @(*)
    begin: enable_signals
        case (current_state)
            start: begin
					current_turn = 4'd0;
					game_over = 2'd0;
				end
            turn1: begin
					current_turn = 4'd1;
					game_over = 2'd0;
				end
            turn2: begin
					current_turn = 4'd2;
					game_over = 2'd0;
				end
            turn3: begin
					current_turn = 4'd3;
					game_over = 2'd0;
				end
            turn4: begin
					current_turn = 4'd4;
					game_over = 2'd0;
				end
            turn5: begin
					current_turn = 4'd5;
					game_over = 2'd0;
				end
	         turn6: begin
					current_turn = 4'd6;
					game_over = 2'd0;
				end
				turn7: begin
					current_turn = 4'd7;
					game_over = 2'd0;
				end
				turn8: begin
					current_turn = 4'd8;
					game_over = 2'd0;
					
				end
				turn9: begin
					current_turn = 4'd9;
					game_over = 2'd0;
				end
				turn10: begin
					current_turn = 4'd10;
					game_over = 2'd0;
				end
				lose: begin
					game_over = 2'd1;
				end
				win: begin
					game_over = 2'd2;
				end
				
				default: begin
					current_turn = 4'd0;
					game_over = 2'd0;
				end
				
        endcase
    end // enable_signals

	 // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= start;
        else
            current_state <= next_state;
    end // state_FFS
	 
endmodule
