`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:17:51 12/24/2020 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top(
	input clk,rst,
	input [15:0] SW,
	output VS,HS,
	output [3:0] r,g,b,
	inout [4:0] BTN_X,
	inout [3:0] BTN_Y,
	output SEGLED_CLK,SEGLED_CLR,SEGLED_DT,SEGLED_PEN,
	input ps2_clk, ps2_data,
	output reg beep,
	output high
    );
	wire over,over1;
	reg over_sign;
	initial over_sign <= 0;
	wire [31:0] clkdiv;
	wire wbeep;
	clkdiv c0(.clk(clk),.rst(rst),.clkdiv(clkdiv));
	
	
	//initialize beep signal
	initial begin
		beep <= 0;
	end
	assign high = 1;
	
	wire [15:0]SW_OK;//SW signal with antijitter control
	AntiJitter #(4) a0[15:0](.clk(clkdiv[15]), .I(SW), .O(SW_OK));
	
	//definition of Keycode and click module of button
	wire [4:0] keyCode;
	wire keyReady;
	Keypad k0 (.clk(clkdiv[15]), .keyX(BTN_Y), .keyY(BTN_X), .keyCode(keyCode), .ready(keyReady));
	
	//definition of Keycode and click module of keyboard
	wire[9:0] ps2_dataout;
	wire ps2_ready;
	PS2_keyboard ps2(.clk(clk), .rst(SW_OK[15]), .ps2_clk(ps2_clk), 
							.ps2_data(ps2_data), .data_out(ps2_dataout), .ready(ps2_ready));
	
	//definition of current direction of pacman
	wire [1:0] pst;
	
	//pacman's position
	wire [9:0] px;    //pacman's x
	wire [9:0] py;		//pacman's y

	//definition of score_display's data
	wire [3:0] sout;

	//difinition of 4 ghosts' position and relative module
	wire [9:0] ghost1X;
	wire [8:0] ghost1Y;
	GhostOne ghost1(.clk(clk), .rst(rst), .x(ghost1X), .y(ghost1Y));	
	
	wire [9:0] ghost2X;
	wire [8:0] ghost2Y;
	GhostTwo ghost2(.clk(clk), .rst(rst), .x(ghost2X), .y(ghost2Y));	
	
	wire [9:0] ghost3X;
	wire [8:0] ghost3Y;
	GhostThree ghost3(.clk(clk), .rst(rst), .x(ghost3X), .y(ghost3Y));	
	
	wire [9:0] ghost4X;
	wire [8:0] ghost4Y;
	GhostFour ghost4(.clk(clk), .rst(rst), .x(ghost4X), .y(ghost4Y));	
	
	//define the array saving beans
	wire [1199:0] beanreg;
	
	//displaymodule of characters
	Display DM(.clk(clk),.rst(rst),.clkdiv(clkdiv),.clrn(SW_OK[0]),.state(pst),.over(over_sign),
		.beanmap(beanreg),
		.r(r), .g(g), .b(b), .hs(HS), .vs(VS),
		.PacX(px),.PacY(py),
		.Ghost1X(ghost1X),.Ghost1Y(ghost1Y),
		.Ghost2X(ghost2X),.Ghost2Y(ghost2Y),
		.Ghost3X(ghost3X),.Ghost3Y(ghost3Y),
		.Ghost4X(ghost4X),.Ghost4Y(ghost4Y));
	
	//key_control module of pacman
	KeyControl Pac(.clk(clk),.rst(rst),
		.keyCode(keyCode),.keyboardCode(ps2_dataout[7:0]),.keyReady(keyReady),.ps2_ready(ps2_ready),
		.PacX(px),.PacY(py),
		.state(pst));
	
	//definition of score
	wire [8:0]score;
	bean b0(.clk(clk), .rst(rst), .pac_x(px), .pac_y(py), .beans(beanreg), .newscore(score), .isover(over1),.beep(wbeep));
	
	//Check Crash between pacman and ghosts
	CheckGhostCrash(.clk(clk), .rst(rst), .PacX(px), .PacY(py),
		.Ghost1X(ghost1X), .Ghost1Y(ghost1Y), .Ghost2X(ghost2X), .Ghost2Y(ghost2Y),
		.Ghost3X(ghost3X), .Ghost3Y(ghost3Y), .Ghost4X(ghost4X), .Ghost4Y(ghost4Y), .result(over));
	
	//score_display module
	wire [31:0] segTestData;
	assign segTestData = {score};
   Seg7Device segDevice(.clkIO(clkdiv[3]), .clkScan(clkdiv[15:14]), .clkBlink(clkdiv[25]),
		.data(segTestData), .point(8'h0), .LES(8'h0),
		.sout(sout));
	assign SEGLED_CLK = sout[3];
	assign SEGLED_DT = sout[2];
	assign SEGLED_PEN = sout[1];
	assign SEGLED_CLR = sout[0];
 	
	//always judging whether the game is over
	always@(posedge clk)begin
		if(over_sign == 0) over_sign <= over == 1 || over1 == 1 ? 1 : 0;
		if(~rst) over_sign <= 0;
		beep <= wbeep;
	end

endmodule
