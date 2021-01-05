`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:01:34 01/05/2021 
// Design Name: 
// Module Name:    CheckGhostCrash 
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
module CheckGhostCrash(
	input clk,rst,
	input [9:0] PacX,GhostX,
	input [8:0] PacY,GhostY,
	output result
    );
	 reg [9:0] x;
	 reg [8:0] y;
	 
	assign result = ((PacX-GhostX)*(PacX-GhostX) + (PacY-GhostY)*(PacY-GhostY) < 2048)? 1 : 0;


endmodule
