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
	input state,
	output reg result
    );
	reg [9:0] x;
	reg [8:0] y;
	
	initial begin
		x <= PacX;
		y <= PacY;
		result <=0;
	end
	
	wire isWall;
	Map Wall(.x(x), .y(y), .isWall(isWall));
	always@(posedge clk)begin
		case(state)
			2'b10://左
				begin
					x <= x - 9'd16;
				end
			2'b11://右
				begin
					x <= x + 9'd16;
				end
			2'b00://上
				begin
					y <= y - 8'd16;
				end
			2'b01://下
				begin
					y <= y + 8'd16;
				end
		endcase

		if(isWall != 1)begin
			result <= 1;//正常
		end
		else begin
			result <= 0;//碰撞
		end
	end
	
	
endmodule
