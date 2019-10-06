module feedback(
	output reg [2:0]color_out,
	input [2:0]c_place,
	input [2:0]c_color,
	input clk,
	input resetn,
	input rest_in_draw
	);

	reg [4:0]stay_in_draw;
	reg [3:0] x_counter, y_counter; // To draw 5x5 pegs
	/*
	always @(*)
		begin
			if(c_place > 0)
				color_out <= 3'b000;
			else if(c_color > 0)
				color_out <= 3'b111;
			else
				color_out <= 3'b010;
		end
	*/	
	localparam black = 3'b000,
					white = 3'b111,
					green = 3'b010;
	
	always @(*)begin
		if(y_counter < c_place)
			color_out <= black;
		else if(y_counter < (c_place + c_color))
			color_out <= white;
		else
			color_out <= green;
	end
	
				// x counter
	always @(posedge clk) begin
		if (!resetn || rest_in_draw)
					x_counter <= 3'd0;
		else if (stay_in_draw > 5'd0) 
			begin
				if (x_counter == 3'd4)
						x_counter <= 3'd0;
				else
					x_counter <= x_counter + 1'd1;
			end
		
	end
	
	assign movedown = (x_counter == 3'd4) ? 1:0;
	
	// y counter
	always @(posedge clk) 
		begin
			if(!resetn || rest_in_draw)
					y_counter <= 3'd0;
			else if (stay_in_draw > 5'd0 && movedown) 
				begin
					if (y_counter != 3'd4)begin
						y_counter <= y_counter + 1'd1;
						end
					else
						y_counter <= 3'b00;	
				end
		end 
				/*	
	reg [2:0] correct_place; //Hold the number of correct places
	reg [2:0] correct_color; //Hold the number of correct colors
	reg [2:0] current_state, next_state; //Keep track of FSM states
	reg [4:0] time_counter; //Count the time to stay in each state for at least 16 cycles
	
	localparam draw_one = 3'b000,
				  draw_two = 3'b001,
				  draw_three = 3'b011,
				  draw_four = 3'b111,
				  draw_five = 3'b110;
	
	reg draw_next; //Move on to the next draw state
	
	//State Table, we will have 5 states, draw corresponding feedback in each
	always @(*)
		begin
			case(current_state)
				draw_one: next_state <= draw_next ? draw_two:draw_one;
				draw_two: next_state <= draw_next ? draw_three:draw_two;
				draw_three: next_state <= draw_next ? draw_four:draw_three;
				draw_four: next_state <= draw_next ? draw_five:draw_four;
				draw_five: next_state <= draw_next ? draw_one:draw_five;
				default: next_state <= draw_one;
			endcase
		end
	
	//Output Table for x value and color
	always @(*)
		begin
			if (current_state == draw_one)begin
				x_out <= 8'd128;
				if(correct_place > 0)begin
					color_out <= 3'b000; //Draw black
					correct_place <= correct_place -1;
				end
				else if(correct_color > 0) begin
					color_out <= 3'b111; //Draw White
					correct_color <= correct_color -1;
				end
				else
					color_out <= 3'b100; // Draw Red
			end
			else if (current_state == draw_two)begin
				x_out <= 8'd133;
				if(correct_place > 0)begin
					color_out <= 3'b000; //Draw black
					correct_place <= correct_place -1;
				end
				else if(correct_color > 0) begin
					color_out <= 3'b111; //Draw White
					correct_color <= correct_color -1;
				end
				else
					color_out <= 3'b100; // Draw Red
			end
			else if (current_state == draw_three)begin
				x_out <= 8'd138;
				if(correct_place > 0)begin
					color_out <= 3'b000; //Draw black
					correct_place <= correct_place -1;
				end
				else if(correct_color > 0) begin
					color_out <= 3'b111; //Draw White
					correct_color <= correct_color -1;
				end
				else
					color_out <= 3'b100; // Draw Red
			end	
			else if (current_state == draw_four)begin
				x_out <= 8'd143;
				if(correct_place > 0)begin
					color_out <= 3'b000; //Draw black
					correct_place <= correct_place -1;
				end
				else if(correct_color > 0) begin
					color_out <= 3'b111; //Draw White
					correct_color <= correct_color -1;
				end
				else
					color_out <= 3'b100; // Draw Red
			end	
			else if (current_state == draw_five)begin
				x_out <= 8'd148;
				if(correct_place > 0)begin
					color_out <= 3'b000; //Draw black
					correct_place <= correct_place -1;
				end
				else if(correct_color > 0) begin
					color_out <= 3'b111; //Draw White
					correct_color <= correct_color -1;
				end
				else
					color_out <= 3'b010; // Draw Green for no rights
			end
		end
	
	//The counter	
	always @(posedge clk)
		begin
			if(!resetn)begin
				draw_next <= 0;
				time_counter <= 5'd16;
			end
			else if(time_counter == 0)begin
				draw_next <= 1;
				time_counter <= 5'd16;
				end
			else begin
				draw_next <= 0;
				time_counter <= time_counter - 1;
			end
		end
		
		
	always @(posedge clk)
		if(!resetn)begin
			current_state <= draw_one;
			end
		else
			current_state <= next_state;
*/
			endmodule
