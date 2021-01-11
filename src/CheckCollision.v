`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:04 01/04/2021 
// Design Name: 
// Module Name:    CheckCollision 
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
module CheckCollision(
	input clk,rst,
	input [9:0] PacX,
	input [8:0]	PacY,
	input [1:0] state,
	output result
    );
	reg [9:0] x;
	reg [8:0] y;
	reg [9:0] x1;
	reg [8:0] y1;
	reg [9:0] x2;
	reg [8:0] y2;
	
	wire isWall, iswall1, iswall2;
	Map Wall(.x(x), .y(y), .isWall(isWall));
	Map Wall1(.x(x1), .y(y1), .isWall(isWall1));
	Map Wall2(.x(x2), .y(y2), .isWall(isWall2));
	
	assign result = ~(isWall|iswall1|iswall2);
	always@(posedge clk)begin
		case(state)
			2'b10://вС
				begin
					x <= PacX - 10'd3;
					y <= PacY + 9'd16;
					x1 <= x;
					y1 <= y + 8;
					x2 <= x;
					y2 <= y - 8;
				end
			2'b11://ср
				begin
					x <= PacX + 10'd35;
					y <= PacY + 9'd16;
					x1 <= x;
					y1 <= y + 8;
					x2 <= x;
					y2 <= y - 8;
				end
			2'b00://ио
				begin
					x <= PacX + 10'd16;
					y <= PacY - 9'd3;
					x1 <= x + 8;
					y1 <= y;
					x2 <= x - 8;
					y2 <= y;
				end
			2'b01://об
				begin
					x <= PacX + 10'd16;
					y <= PacY + 9'd35;
					x1 <= x + 8;
					y1 <= y;
					x2 <= x - 8;
					y2 <= y;
				end
		endcase
	end
	
	
endmodule
