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
	input ps2_clk, ps2_data
    );
	wire over,over1;
	reg over_sign;
	initial over_sign <= 0;
	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk),.rst(rst),.clkdiv(clkdiv));
	
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

	//ghost1's position
	wire [9:0] ghost1X;
	wire [8:0] ghost1Y;
	Ghost_M ghost1(.clk(clkdiv[24]), .x(ghost1X), .y(ghost1Y));	
	
	//displaymodule of characters
	Display DM(.clk(clk),.clkdiv(clkdiv),.clrn(SW_OK[0]),.state(pst),
		.r(r), .g(g), .b(b), .hs(HS), .vs(VS),
		.PacX(px),.PacY(py),.GhostX(ghost1X),.GhostY(ghost1Y));
	
	//key_control module of pacman
	KeyControl Pac(.clk(clk),.rst(rst),
		.keyCode(KeyCode),.keyboardCode(ps2_dataout[7:0]),.keyReady(KeyReady),.ps2_ready(ps2_ready),
		.PacX(px),.PacY(py),
		.state(pst));
		
	CheckGhostCrash(.clk(clk),.rst(rst),.PacX(px),.PacY(py),.GhostX(ghost1X),.GhostY(ghost1Y),.result(over));
	
	//score_display module
	wire [31:0] segTestData;
	assign segTestData = {31'b0,over_sign};
   Seg7Device segDevice(.clkIO(clkdiv[3]), .clkScan(clkdiv[15:14]), .clkBlink(clkdiv[25]),
		.data(segTestData), .point(8'h0), .LES(8'h0),
		.sout(sout));
	assign SEGLED_CLK = sout[3];
	assign SEGLED_DT = sout[2];
	assign SEGLED_PEN = sout[1];
	assign SEGLED_CLR = sout[0];
 	
	always@(posedge clk)begin
		over_sign <= over == 1 || over1 == 1 ? 1 : 0;
	end

endmodule
