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

	reg [1:0] state;
	wire [1:0] pst;
	//显示模块
	
	reg [9:0] PacX;
	wire [9:0] px;
	initial  PacX = 10'd30;
	reg [8:0] PacY;
	wire [9:0] py;
	initial PacY = 9'd146;
	
	reg [9:0] GhostX;
	initial  GhostX = 10'd250;
	reg [8:0] GhostY;
	initial GhostY = 9'd146;
	

	//显示模块
	Display DM(.clk(clkdiv[1]),.clrn(SW_OK[0]),.state(state),
		.r(r), .g(g), .b(b), .hs(HS), .vs(VS),
		.PacX(PacX),.PacY(PacY),.GhostX(GhostX),.GhostY(GhostY));
	
	
	//控制模块移动
	KeyControl Pac(.clk(clk),.rst(rst),
		.keyCode(KeyCode),.keyboardCode(ps2_dataout[7:0]),.keyReady(KeyReady),.ps2_ready(ps2_ready),
		.x(px),.y(py),
		.state(pst));
	
	//显示数据模块
	wire [31:0] segTestData;
	assign segTestData = {7'b0,PacX,8'b0,PacY};
	wire [3:0]sout;
   Seg7Device segDevice(.clkIO(clkdiv[3]), .clkScan(clkdiv[15:14]), .clkBlink(clkdiv[25]),
		.data(segTestData), .point(8'h0), .LES(8'h0),
		.sout(sout));
	assign SEGLED_CLK = sout[3];
	assign SEGLED_DT = sout[2];
	assign SEGLED_PEN = sout[1];
	assign SEGLED_CLR = sout[0];
 	
	always@(posedge clk)begin
		PacX <= px;
		PacY <= py;
		state <= pst;
	end
	
endmodule
