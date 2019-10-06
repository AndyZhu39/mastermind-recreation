module lord_brain(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		
		//DELETE LATER
		SW,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		LEDR,
		
		// Your inputs and outputs here
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		PS2_CLK,
		PS2_DAT
	);

	input 		[9:0]SW;
	inout 		PS2_CLK;
	inout			PS2_DAT;
	input			CLOCK_50;				//	50 MHz
	// Declare your inputs and outputs here
	// Do not change the following outputs
	input [1:0]KEY;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	//DELETE LATER
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [9:0] LEDR;
	hexDecoder h0(.segments(HEX0[6:0]),.code(y[3:0]));
	hexDecoder h1(.segments(HEX1[6:0]),.code(y[6:4]));
	hexDecoder h2(.segments(HEX2[6:0]),.code(x[3:0]));
	hexDecoder h3(.segments(HEX3[6:0]),.code(x[7:4]));
	hexDecoder h4(.segments(HEX4[6:0]),.code(ccorrect_place));
	hexDecoder h5(.segments(HEX5[6:0]),.code(cstate_in));
	assign LEDR[0] = writeEn;
					

	wire resetn;
	assign resetn = KEY[0];
	
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(ccolor),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "image.colour.mif";
			
			wire [7:0] cx;
			wire [6:0] cy;
			wire cdraw;
			wire cdatapath_write;
			wire [4:0] ckeyboard;
			wire [3:0]cstate_in; //Connect what state we are in
			wire [3:0] cturns; //connect the turns
			wire [1:0] cgo; //Go to the next turn
			wire [1:0] cgame_over;
			wire [2:0] ccolor;
			wire [7:0] cfeedback_x;
			wire [2:0] cfb_color;
			wire [2:0] ccorrect_place;
			wire [2:0] ccorrect_color;
			
//ORIGINALS
//datapath d0(.clk(CLOCK_50), .x_out(x), .y_out(y), .color_out(colour), .draw_out(writeEn), .color_in(ckeyboard[2:0]), .x_in(cx), .y_in(cy), .datapath_write(cdatapath_write), .draw_in(cdraw), .resetn(resetn));
//control c0(.clk(CLOCK_50), .x_out(cx), .y_out(cy), .datapath_write(cdatapath_write), .draw(cdraw), .turn(4'd0), .data(ckeyboard[4:3]), .resetn(resetn), .go(go));
//lbkeyboard keyboard(.PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .clk(CLOCK_50), .resetn(resetn), .kb_out(ckeyboard));
	
	peg_comparator pgc (.ans_1(3'b000), .ans_2(3'b000), .ans_3(3'b000), .ans_4(3'b000), .ans_5(3'b010),
								.guess_1(3'b000), .guess_2(3'b000), .guess_3(3'b001), .guess_4(3'b010), .guess_5(3'b000),
								.cor_p(ccorrect_place), .cor_c(ccorrect_color), .win());
	
	turncounter tcounter(.data(cgo), .resetn(resetn), .current_turn(cturns), .clk(CLOCK_50), .game_over(cgame_over));
	
	//lbtimer timer (.clk(CLOCK_50), .pulse(), .resetn(resetn), .next_turn());

	lbkeyboard2 keyboard(.PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .clk(CLOCK_50),
	.resetn(resetn), .kb_out(ckeyboard));

	feedback fb(.x_out(cfeedback_x), .color_out(cfb_color), .c_place(ccorrect_place), 
					.c_color(ccorrect_color), .clk(CLOCK_50), .resetn(resetn));

					
	datapath d0(.clk(CLOCK_50), .x_out(x), .y_out(y), .draw_in(writeEn),
					.x_in(cx), .y_in(cy), .datapath_write(cdatapath_write), .resetn(resetn));
	
	control c0(.clk(CLOCK_50), .x_out(cx), .y_out(cy), .datapath_write(cdatapath_write), .color_in(ckeyboard[2:0]),
				.color_out(ccolor), .draw(writeEn), .turn(cturns), .data(ckeyboard[4:3]), .fb_color(cfb_color), 
				.resetn(resetn), .go(cgo), .state_out(cstate_in), .fb_x(cfeedback_x));	
endmodule
	

module hexDecoder(
	output reg [6:0] segments,
	input [3:0] code);
	always @(*)
		case(code)
				4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
       endcase	
endmodule
