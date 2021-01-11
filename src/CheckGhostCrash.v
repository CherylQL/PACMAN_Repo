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
	input [9:0] PacX, Ghost1X, Ghost2X, Ghost3X, Ghost4X,
	input [8:0] PacY, Ghost1Y, Ghost2Y, Ghost3Y, Ghost4Y,
	output result
    );
	 reg [9:0] x;
	 reg [8:0] y;
	 
	assign result = ((PacX - Ghost1X) * (PacX - Ghost1X) + (PacY - Ghost1Y) * (PacY - Ghost1Y) < 2048)
		||((PacX - Ghost2X) * (PacX - Ghost2X) + (PacY - Ghost2Y) * (PacY - Ghost2Y) < 2048) 
		||((PacX - Ghost3X) * (PacX - Ghost3X) + (PacY - Ghost3Y) * (PacY - Ghost3Y) < 2048) 
		||((PacX - Ghost4X) * (PacX - Ghost4X) + (PacY - Ghost4Y) * (PacY - Ghost4Y) < 2048); 

endmodule
