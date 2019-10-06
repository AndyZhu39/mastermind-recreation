module control(
	output reg [7:0]x_out, //x Coordinates to draw the square
	output reg [6:0]y_out, //y Coordinates to draw the square
	output reg datapath_write, //Write to the datapath
	output reg draw,		//Plot for the VGA
	output reg [1:0] go, //go to the next turn
	output reg [3:0] state_out, //What state of FSM WE're in
	output reg [2:0]color_out,
	input clk,
	input [3:0]turn,
	input [1:0]data,
	input win,
	input [2:0]color_in,
	input [2:0] fb_color,
	input resetn,
	input [7:0] fb_x); //x coordinate for feedback
	
	reg [4:0] current_state, next_state;
	
	
	localparam 	TP1 = 5'b00000,
				WP1 = 5'b00001,
				DP1 = 5'b00011,
				TP2 = 5'b00111,
				WP2 = 5'b01111,
				DP2 = 5'b11111,
				TP3 = 5'b11110,
				WP3 = 5'b11100,
				DP3 = 5'b11000,
				TP4 = 5'b10000,
				WP4 = 5'b10001,
				DP4 = 5'b10011,
				TP5 = 5'b10111,
				WP5 = 5'b10101,
				DP5 = 5'b11101,
				FBW = 5'b11001,
				FB = 5'b01001,
				FBD = 5'b01000;
					
	//State Table
	always @(*)
		begin
			case(current_state)
				TP1: begin
						if (data[1:0] == 2'b00)
							next_state <= TP1;
						else if (data[1:0] == 2'b10)
							next_state <= TP1;
						else
							next_state <= WP1;
						end
				WP1: begin								//In wait and draw states, move on only if
						if (data[1:0] == 2'b00)		//the signal is 00, stay otherwise
							next_state <= DP1;
						else
							next_state <= WP1;
						end
				DP1: begin
						if (data[1:0] == 2'b00)
							next_state <= DP1;
						else if (data[1:0] == 2'b10)
							next_state <= TP1;
						else
							next_state <= TP2;
						end
				TP2: begin
						if (data[1:0] == 2'b00)
							next_state <= TP2;
						else if (data[1:0] == 2'b10)
							next_state <= TP2;
						else
							next_state <= WP2;
						end
				WP2: begin
						if (data[1:0] == 2'b00)
							next_state <= DP2;
						else
							next_state <= WP2;
						end
				DP2: begin
						if (data[1:0] == 2'b00)
							next_state <= DP2;
						else if (data[1:0] == 2'b10)
							next_state <= TP2;
						else
							next_state <= TP3;
						end
				TP3: begin
						if (data[1:0] == 2'b00)
							next_state <= TP3;
						else if (data[1:0] == 2'b10)
							next_state <= TP3;
						else
							next_state <= WP3;
						end
				WP3: begin
						if (data[1:0] == 2'b00)
							next_state <= DP3;
						else
							next_state <= WP3;
						end
				DP3: begin
						if (data[1:0] == 2'b00)
							next_state <= DP3;
						else if (data[1:0] == 2'b10)
							next_state <= TP3;
						else
							next_state <= TP4;
						end
				TP4: begin
						if (data[1:0] == 2'b00)
							next_state <= TP4;
						else if (data[1:0] == 2'b10)
							next_state <= TP4;
						else
							next_state <= WP4;
						end
				WP4: begin
						if (data[1:0] == 2'b00)
							next_state <= DP4;
						else
							next_state <= WP4;
						end
				DP4: begin
						if (data[1:0] == 2'b00)
							next_state <= DP4;
						else if (data[1:0] == 2'b10)
							next_state <= TP4;
						else
							next_state <= TP5;
						end
				TP5: begin
						if (data[1:0] == 2'b00)
							next_state <= TP5;
						else if (data[1:0] == 2'b10)
							next_state <= TP5;
						else
							next_state <= WP5;
						end
				WP5: begin
						if (data[1:0] == 2'b00)
							next_state <= DP5;
						else
							next_state <= WP5;
						end
				DP5: begin
						if (data[1:0] == 2'b00)
							next_state <= DP5;
						else if (data[1:0] == 2'b10)
							next_state <= TP5;
						else
							next_state <= FB;
						end
				FBW: begin
						if(data[1:0] == 2'b00)
							next_state <= FB;
						else
							next_state <= FBW;
						end
				FB: begin
					if (data[1:0] == 2'b00)
						next_state <= FBD;
					else
						next_state <= FB;
					end
				FBD: begin
						if (data[1:0] == 2'b00) //Draw and wait for signal to go into next turn
							next_state <= FBD;
						else
							next_state <= TP1;
						end
				default: 
					current_state <= TP1;
				endcase
				end
				
	//Output Table
	always @(*)
		begin 
			case(current_state)
					TP1 : begin
						x_out <= {1'b0,7'd38};
						datapath_write <= 1'b1;
						state_out <= 4'd0;
						draw <= 1'b0;
						color_out <= color_in;
						if(win)
							go <= 2'b10;
						else
							go <= 2'b00;
						end
					WP1 : begin
						x_out <= {1'b0,7'd38};
						datapath_write <= 1'b0;
						state_out <= 4'd1;
						draw <= 1'b0;
						go <= 2'b00;
						end
					DP1 : begin
						x_out <= {1'b0,7'd38};
						datapath_write <= 1'b0;
						draw <= 1'b1;
						state_out <= 4'd2;
						go <= 2'b00;
						end
					TP2 : begin
						x_out <= {1'b0,7'd54};
						datapath_write <= 1'b1;
						state_out <= 4'd3;
						draw <= 1'b0;	
						color_out <= color_in;
						go <= 2'b00;
						end
					WP2 : begin
						x_out <= {1'b0,7'd54};
						datapath_write <= 1'b0;
						state_out <= 4'd4;
						draw <= 1'b0;
						go <= 2'b00;
						end
					DP2 : begin
						x_out <= {1'b0,7'd54};
						datapath_write <= 1'b0;
						draw <= 1'b1;
						state_out <= 4'd5;
						go <= 2'b00;
						end
					TP3 : begin
						x_out <= {1'b0,7'd70};
						datapath_write <= 1'b1;
						state_out <= 4'd6;
						draw <= 1'b0;
						color_out <= color_in;
						go <= 2'b00;
						end
					WP3 : begin
						x_out <= {1'b0,7'd70};
						datapath_write <= 1'b0;
						state_out <= 4'd7;
						draw <= 1'b0;
						go <= 2'b00;
						end
					DP3 : begin
						x_out <= {1'b0,7'd70};
						datapath_write <= 1'b0;
						draw <= 1'b1;
						state_out <= 4'd8;
						go <= 2'b00;
						end
					TP4 : begin
						x_out <= {1'b0,7'd86};
						datapath_write <= 1'b1;
						state_out <= 4'd9;
						draw <= 1'b0;
						color_out <= color_in;
						go <= 2'b00;
						end
					WP4 : begin
						x_out <= {1'b0,7'd86};
						datapath_write <= 1'b0;
						state_out <= 4'd10;
						draw <= 1'b0;
						go <= 2'b00;
						end
					DP4 : begin
						x_out <= {1'b0,7'd86};
						datapath_write <= 1'b0;
						draw <= 1'b1;
						state_out <= 4'd11;
						go <= 2'b00;
						end
					TP5 : begin
						x_out <= {1'b0,7'd102};
						datapath_write <= 1'b1;
						state_out <= 4'd12;
						draw <= 1'b0;
						color_out <= color_in;
						go <= 2'b00;
						end
					WP5 : begin
						x_out <= {1'b0,7'd102};
						datapath_write <= 1'b0;
						state_out <= 4'd13;
						draw <= 1'b0;
						go <= 2'b00;
						end
					DP5 : begin
						x_out <= {1'b0,7'd102};
						datapath_write <= 1'b0;
						draw <= 1'b1;
						state_out <= 4'd14;
						end
					FB: begin
						x_out <= fb_x;
						datapath_write <= 1'b1;
						draw <= 1'b0;
						state_out <= 4'd14;
						go <= 2'b00;
						end
					FBD: begin
						x_out <= fb_x;
						datapath_write <= 1'b0;
						draw <= 1'b1;
						state_out <= 4'd14;
						color_out <= fb_color;
						if(data == 2'b01)
								go <= 2'b01;
						else
							go <= 2'b00;
						end
						
					default: 
						begin
							x_out <= {1'b1,7'd0};	//We always know the x value
							datapath_write <= 1'b0; //Write the position into the datapath
							draw <= 1'b0; // Draw the next peg
							state_out <= 4'd0;
							go <= 2'b00;
						end
				endcase
		end
	//y value depends on what turn we are in
	always @(*)
		begin
			case(turn)
					4'd0: y_out <= 7'd24;
					4'd1: y_out <= 7'd30;
					4'd2: y_out <= 7'd36;
					4'd3: y_out <= 7'd42;
					4'd4: y_out <= 7'd48;
					4'd5: y_out <= 7'd54;
					4'd6: y_out <= 7'd60;
					4'd7: y_out <= 7'd66;
					4'd8: y_out <= 7'd72;
					4'd9: y_out <= 7'd78;
			endcase
		end
	//Setup a synchronus reset
	always @(posedge clk)
		begin
			if(!resetn)
				current_state <= TP1;
			else
				current_state <= next_state;
		end
endmodule
