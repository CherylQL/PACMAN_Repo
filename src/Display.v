`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:40 12/28/2020 
// Design Name: 
// Module Name:    Display 
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
module Display(
	input clk,
	input rst,
	input [31:0] clkdiv,
	input clrn,
	input over,
	input [1199:0] beanmap,
	input [1:0] state,
	input [9:0] PacX,
	input [8:0]	PacY,
	input [9:0] Ghost1X,
	input [8:0] Ghost1Y,
	input [9:0] Ghost2X,
	input [8:0] Ghost2Y,
	input [9:0] Ghost3X,
	input [8:0] Ghost3Y,
	input [9:0] Ghost4X,
	input [8:0] Ghost4Y,
   output [3:0] r,g,b, // red, green, blue colors
   output hs,vs  // horizontal and vertical synchronization
    );

	reg [11:0] vga_data;
	wire [9:0] col_addr;
 	wire [8:0] row_addr;
	
	reg [16:0] end_ip;
	wire [11:0] end_color;
	gameover end_pic(.addra(end_ip),.douta(end_color),.clka(clk));
	
	reg [9:0] pac_add_ip;
	wire [11:0] pac_inner_color;
	PacSelf P(.a(pac_add_ip),.spo(pac_inner_color));
	
	reg [9:0] ghost_add_ip;
	wire [11:0] ghost_inner_color;
	Ghost G(.a(ghost_add_ip),.spo(ghost_inner_color));
	
	vgac vga (
		.vga_clk(clkdiv[1]), .clrn(clrn), .d_in(vga_data), .row_addr(row_addr), .col_addr(col_addr), .r(r), .g(g), .b(b), .hs(hs), .vs(vs)
	);
	
	wire isWall;
	Map Wall(.x(col_addr), .y(row_addr), .isWall(isWall));
	wire isbean;
	beanmap Bean(.x(col_addr), .y(row_addr), .beanmapData(beanmap), .isbean(isbean));
	
	
	always@(* ) begin
			if(over == 1)begin
				if(row_addr >= 10'd100 && row_addr < 10'd290 && col_addr >= 9'd180  && col_addr < 9'd500)begin
					end_ip <= (row_addr - 9'd120)* 267 + col_addr - 10'd158;
					vga_data <= end_color;
				end
				else begin
					vga_data <= 12'h0;
				end
			end
			else begin
				if(isWall) begin
					vga_data <= 12'hfff;
				end
				else if(row_addr >= Ghost1Y && row_addr < Ghost1Y + 32 && col_addr >= Ghost1X  && col_addr < Ghost1X + 32)begin
					ghost_add_ip <= (row_addr - Ghost1Y) * 32 + (col_addr - Ghost1X);
					vga_data <= ghost_inner_color;
				end
				else if(row_addr >= Ghost2Y && row_addr < Ghost2Y + 32 && col_addr >= Ghost2X  && col_addr < Ghost2X + 32)begin
					ghost_add_ip <= (row_addr - Ghost2Y) * 32 + (col_addr - Ghost2X);
					vga_data <= ghost_inner_color;
				end
				else if(row_addr >= Ghost3Y && row_addr < Ghost3Y + 32 && col_addr >= Ghost3X  && col_addr < Ghost3X + 32)begin
					ghost_add_ip <= (row_addr - Ghost3Y) * 32 + (col_addr - Ghost3X);
					vga_data <= ghost_inner_color;
				end
				else if(row_addr >= Ghost4Y && row_addr < Ghost4Y + 32 && col_addr >= Ghost4X  && col_addr < Ghost4X + 32)begin
					ghost_add_ip <= (row_addr - Ghost4Y) * 32 + (col_addr - Ghost4X);
					vga_data <= ghost_inner_color;
				end
				else if(isbean) begin
					vga_data <= 12'hff0;
				end
				else if(row_addr >= PacY && row_addr < PacY + 32 && col_addr >= PacX  && col_addr < PacX + 32)begin
					if(state == 2'b00)
						pac_add_ip <= (col_addr - PacX) * 32 + (row_addr - PacY);
					else if(state == 2'b01)
						pac_add_ip <= (col_addr - PacX) * 32 + (32 - row_addr + PacY);
					else if(state == 2'b10)
						pac_add_ip <= (row_addr - PacY) * 32 + (col_addr - PacX);
					else
						pac_add_ip <= (row_addr - PacY) * 32 + (32 - col_addr + PacX);
					vga_data <= pac_inner_color;
				end
				else begin
					vga_data <= 3'h0;
				end
			end
		end
endmodule
