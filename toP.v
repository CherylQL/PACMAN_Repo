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
	
	wire [15:0]SW_OK;//��������֮���SW�ź�
	AntiJitter #(4) a0[15:0](.clk(clkdiv[15]), .I(SW), .O(SW_OK));
	
	//��ť�ź�
	wire [4:0] keyCode;
	wire keyReady;
	Keypad k0 (.clk(clkdiv[15]), .keyX(BTN_Y), .keyY(BTN_X), .keyCode(keyCode), .ready(keyReady));
	
	//�����ź�
	wire[9:0] ps2_dataout;
	wire ps2_ready;
	PS2_keyboard ps2(.clk(clk), .rst(SW_OK[15]), .ps2_clk(ps2_clk), 
							.ps2_data(ps2_data), .data_out(ps2_dataout), .ready(ps2_ready));
	
	
	//��ʾģ��
 	reg [11:0] vga_data;
 	wire [9:0] col_addr;
 	wire [8:0] row_addr;
	
	reg [9:0] PacX;
	initial  PacX = 10'd30;
	reg [8:0] PacY;
	initial PacY = 9'd146;
	
	
	reg [9:0] pac_add_ip;
	wire [11:0] pac_inner_color;
	PacSelf P(.a(pac_add_ip),.spo(pac_inner_color));
	
	reg [9:0] GhostX;
	initial  GhostX = 10'd250;
	reg [8:0] GhostY;
	initial GhostY = 9'd146;
	
	reg [9:0] ghost_add_ip;
	wire [11:0] ghost_inner_color;
	Ghost G(.a(ghost_add_ip),.spo(ghost_inner_color));
	
	always@(* ) begin
		if(row_addr >= GhostY && row_addr < GhostY + 32 && col_addr >= GhostX  && col_addr < GhostX + 32)begin
			ghost_add_ip <= (row_addr - GhostY) * 32 + (col_addr - GhostX);
			vga_data <= ghost_inner_color;
		end
		else if(row_addr >= PacY && row_addr < PacY + 32 && col_addr >= PacX  && col_addr < PacX + 32)begin
			//case (state)
				//2'b00:pac_add_ip <= (row_addr - PacY) * 32 + (col_addr - PacX);
				//2'b01:pac_add_ip <= (row_addr - PacY) * 32 + (col_addr - PacX);
				//2'b10:pac_add_ip <= (row_addr - PacY) * 32 + (col_addr - PacX);
				//2'b11:pac_add_ip <= (row_addr - PacY) * 32 + (col_addr - PacX);
			//endcase
			if(state == 2'b00)//��
				pac_add_ip <= (col_addr - PacX) * 32 + (row_addr - PacY);
			else if(state == 2'b01)//��
				pac_add_ip <= (col_addr - PacX) * 32 + (32 - row_addr + PacY);
			else if(state == 2'b10)//��
				pac_add_ip <= (row_addr - PacY) * 32 + (col_addr - PacX);
			else//��
				pac_add_ip <= (row_addr - PacY) * 32 + (32 - col_addr + PacX);
			vga_data <= pac_inner_color;
		end
		else begin
			vga_data <= 3'h0;
		end
	end
	
	reg [1:0] state;
	initial state = 2'b0;
	
	
	
	vgac vga (
		.vga_clk(clkdiv[1]), .clrn(SW_OK[0]), .d_in(vga_data), .row_addr(row_addr), .col_addr(col_addr), .r(r), .g(g), .b(b), .hs(HS), .vs(VS)
	);
	
	//����ģ���ƶ�
	reg wasReady;
	always @(posedge clk) begin
		if (!rst) begin
			PacX <= 10'd320;
			PacY <= 9'd240;
		end else begin
			wasReady <= keyReady;
			if (!wasReady&&keyReady) begin
				case (keyCode)
					5'hc: PacX <= PacX - 10'd32;
					5'he: PacX <= PacX + 10'd32;
					5'h9: PacY <= PacY - 9'd32;
					5'h11: PacY <= PacY + 9'd32;
					default: ;
				endcase
			end
			
			if (!wasReady&&ps2_ready) begin
				case (ps2_dataout[7:0])
					8'h6b:	//������
						begin
							PacX <= PacX - 10'd32;
							state <= 2'b10;
						end
					8'h74: 	//������
						begin
							PacX <= PacX + 10'd32;
							state <= 2'b11;
						end
					8'h75: 	//������
						begin
							PacY <= PacY - 9'd32;
							state <= 2'b00;
						end
					8'h72:	//������
						begin
							PacY <= PacY + 9'd32;
							state <= 2'b01;
						end
					default: ;
				endcase
			end
		end
	end
	
	//��ʾ����ģ��
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
 	
	
endmodule