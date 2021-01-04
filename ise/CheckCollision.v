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
	
	initial begin
		x <= PacX;
		y <= PacY;
	end
	
	wire isWall;
	Map Wall(.x(x), .y(y), .isWall(isWall));
	
	assign result = ~isWall;
	always@(posedge clk)begin
		case(state)
			2'b10://вС
				begin
					x = x - 10'd8;
				end
			2'b11://ср
				begin
					x = x + 10'd8;
				end
			2'b00://ио
				begin
					y = y - 9'd8;
				end
			2'b01://об
				begin
					y = y + 9'd8;
				end
		endcase
	end
	
	
endmodule
