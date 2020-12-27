`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:57 12/27/2020 
// Design Name: 
// Module Name:    ifcrash 
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
module ifcrash(input wire [9:0]pac_x,
					input wire [8:0]pac_y,
					input wire [9:0]x,
					input wire [8:0]y,
					output reg bool
    );
	 
	always@(*)begin 
		if(x >= pac_x && x <= pac_x + 32 && y >= pac_y  && y <= pac_y + 32) bool <= 1;
		else bool <= 0;
	end

endmodule
