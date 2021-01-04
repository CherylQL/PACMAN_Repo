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
	input [31:0] clkdiv,
	input clrn,
	input [1:0] state,
	input [9:0] PacX,
	input [8:0]	PacY,
	input [9:0] GhostX,
	input [8:0] GhostY,
   output [3:0] r,g,b, // red, green, blue colors
   output hs,vs  // horizontal and vertical synchronization
    );

	reg [11:0] vga_data;
	wire [9:0] col_addr;
 	wire [8:0] row_addr;
	
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
	//wire isbean;
	//beanmap Bean(.x(row_addr), .y(col_addr), .isbean(isbean), .bmap());
	
	always@(* ) begin
		if(isWall) begin
			vga_data <= 12'hfff;
		end
		//else if(isbean) begin
			//vga_data <= 12'hff0;
		//end
		else if(row_addr >= GhostY && row_addr < GhostY + 32 && col_addr >= GhostX  && col_addr < GhostX + 32)begin
			ghost_add_ip <= (row_addr - GhostY) * 32 + (col_addr - GhostX);
			vga_data <= ghost_inner_color;
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
endmodule
