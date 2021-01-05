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
	
	
	wire isWall;
	Map Wall(.x(x), .y(y), .isWall(isWall));
	
	assign result = ~isWall;
	always@(posedge clk)begin
		case(state)
			2'b10://вС
				begin
					x <= PacX - 10'd3;
					y <= PacY + 9'd16;
				end
			2'b11://ср
				begin
					x <= PacX + 10'd35;
					y <= PacY + 9'd16;
				end
			2'b00://ио
				begin
					x <= PacX + 10'd16;
					y <= PacY - 9'd3;
				end
			2'b01://об
				begin
					x <= PacX + 10'd16;
					y <= PacY + 9'd35;
				end
		endcase
	end
	
	
endmodule
