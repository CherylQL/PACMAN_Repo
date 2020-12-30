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
	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk),.rst(rst),.clkdiv(clkdiv));
	
	wire [15:0]SW_OK;//防抖控制之后的SW信号
	AntiJitter #(4) a0[15:0](.clk(clkdiv[15]), .I(SW), .O(SW_OK));
	
	//按钮信号
	wire [4:0] keyCode;
	wire keyReady;
	Keypad k0 (.clk(clkdiv[15]), .keyX(BTN_Y), .keyY(BTN_X), .keyCode(keyCode), .ready(keyReady));
	
	//键盘信号
	wire[9:0] ps2_dataout;
	wire ps2_ready;
	PS2_keyboard ps2(.clk(clk), .rst(SW_OK[15]), .ps2_clk(ps2_clk), 
							.ps2_data(ps2_data), .data_out(ps2_dataout), .ready(ps2_ready));

	wire [1:0] pst;
	//显示模块
	
	wire [9:0] px;    //pacman's x
	wire [9:0] py;		//pacman's y
	
	
	reg [9:0] GhostX; //ghost's x
	reg [8:0] GhostY; //ghost's y
	initial GhostX = 10'd200;
	initial GhostY = 9'd146;
	

	wire [3:0] sout;
	
	
	
	Display DM(.clk(clk),.clkdiv(clkdiv),.clrn(SW_OK[0]),.state(pst),
		.r(r), .g(g), .b(b), .hs(HS), .vs(VS),
		.PacX(px),.PacY(py),.GhostX(GhostX),.GhostY(GhostY));
	
	
	//控制模块移动
	KeyControl Pac(.clk(clk),.rst(rst),
		.keyCode(KeyCode),.keyboardCode(ps2_dataout[7:0]),.keyReady(KeyReady),.ps2_ready(ps2_ready),
		.PacX(px),.PacY(py),
		.state(pst));
	
	//显示数据模块
	wire [31:0] segTestData;
	assign segTestData = {7'b0,px,8'b0,py};
   Seg7Device segDevice(.clkIO(clkdiv[3]), .clkScan(clkdiv[15:14]), .clkBlink(clkdiv[25]),
		.data(segTestData), .point(8'h0), .LES(8'h0),
		.sout(sout));
	assign SEGLED_CLK = sout[3];
	assign SEGLED_DT = sout[2];
	assign SEGLED_PEN = sout[1];
	assign SEGLED_CLR = sout[0];
 	

endmodule
