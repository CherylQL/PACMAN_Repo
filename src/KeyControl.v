`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:43 12/28/2020 
// Design Name: 
// Module Name:    KeyControl 
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
module KeyControl(
   input clk,rst,
	input [4:0] keyCode,
	input [7:0] keyboardCode,
	input keyReady,ps2_ready,
	output reg [9:0] PacX,
	output reg [8:0] PacY,
	output reg [1:0] state
    );
		
	reg [1:0] state_;
	initial state_ = 2'b0;

	initial PacX = 10'd30;
	initial PacY = 9'd146;
	

	reg wasReady;
	always@ (posedge clk)begin
		if (!rst) begin
			PacX <= 10'd320;
			PacY <= 9'd240;
		end else begin
			wasReady <= keyReady;
			if (!wasReady&&keyReady) begin
				case (keyCode)
					5'hc:
						begin
							PacX <= PacX - 10'd32;
							state <= 2'b10;
						end
					5'he: 
						begin
							PacX <= PacX + 10'd32;
							state <= 2'b11;
						end
					5'h9: 
						begin
							PacY <= PacY + 9'd32;
							state <= 2'b01;
						end
					5'h11: 
						begin
							PacY <= PacY - 9'd32;
							state <= 2'b00;
						end
					default: ;
				endcase
			end
			
			if (!wasReady&&ps2_ready) begin
				case (keyboardCode)
					8'h6b:	//¼üÅÌ×ó
						begin
							PacX <= PacX - 10'd32;
							state <= 2'b10;
						end
					8'h74: 	//¼üÅÌÓÒ
						begin
							PacX <= PacX + 10'd32;
							state <= 2'b11;
						end
					8'h75: 	//¼üÅÌÉÏ
						begin
							PacY <= PacY - 9'd32;
							state <= 2'b00;
						end
					8'h72:	//¼üÅÌÏÂ
						begin
							PacY <= PacY + 9'd32;
							state <= 2'b01;
						end
					default: ;
				endcase
			end
		end
	end
endmodule
