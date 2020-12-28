`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:28:45 11/09/2019 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(
		input clk,
		input rst,
		output reg[31:0]clkdiv
    );
	 
	 always @ (posedge clk) begin
		clkdiv <= clkdiv + 1'b1;
	end

endmodule
