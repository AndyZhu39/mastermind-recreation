module datapath(
	output [7:0]x_out,
	output [6:0]y_out,
	input rest_in_draw,
	input clk,
	input [7:0]x_in,
	input [6:0]y_in,
	input datapath_write,
	input draw_in,
	input resetn);
	
	
	reg [4:0]stay_in_draw;
	reg [7:0]x; 
	reg [6:0]y;
	reg [1:0] x_counter, y_counter; // To draw 4x4 pegs
	wire movedown;
	always @(posedge clk)
		begin
			if(!resetn)begin
				x <= 8'd0;
				y <= 7'd0;
			end
			else if(datapath_write == 1'b1) begin
				x <= x_in;
				y <= y_in;
			end
		end
		
	//Stay in draw for 16 cycles
	always @(posedge clk) begin
		if(rest_in_draw)
			stay_in_draw <= 5'd0;
		if(draw_in == 1'b1)begin
			stay_in_draw <= 5'd16;
			end
		if(draw_in == 0)
			stay_in_draw <= 5'd0;
		if(stay_in_draw < 0)begin
			stay_in_draw <= 5'd0;
		end
		else if (stay_in_draw > 0) begin
			stay_in_draw <= stay_in_draw - 1'b1;
			end
	end
		
		// x counter
	always @(posedge clk) begin
		if (!resetn || rest_in_draw)
					x_counter <= 2'd0;
		else if (stay_in_draw > 5'd0) 
			begin
				if (x_counter == 2'd3)
						x_counter <= 2'd0;
				else
					x_counter <= x_counter + 1'd1;
			end
		
	end
	
	assign movedown = (x_counter == 4'd3) ? 1:0;
	
	// y counter
	always @(posedge clk) 
		begin
			if(!resetn || rest_in_draw)
					y_counter <= 2'd0;
			else if (stay_in_draw > 5'd0 && movedown) 
				begin
					if (y_counter != 2'd3)begin
						y_counter <= y_counter + 1'd1;
						end
					else
						y_counter <= 2'b00;	
				end
		end 
	
	assign x_out = x + {4'b0000, x_counter};
	assign y_out = y + {3'b000, y_counter};
//	assign color_out = color_in;
endmodule
		
				
			