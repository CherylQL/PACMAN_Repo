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
		
	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk),.rst(rst),.clkdiv(clkdiv));
	initial state = 2'b0;
	
	reg [1:0] state_;
	initial state_ = 2'b0;

	initial PacX = 10'd320;
	initial PacY = 9'd146;
	
	wire result_l;
	wire result;
	
	//turn permission;result = 1 means permitted
	CheckCollision cc_turn(.clk(clk),.rst(rst),.PacX(PacX),.PacY(PacY),.state(state_),.result(result));
	
	//move forward permission;result_1 = 1 means permitted
	CheckCollision cc_line(.clk(clk),.rst(rst),.PacX(PacX),.PacY(PacY),.state(state),.result(result_l));
	
	
	reg wasReady;
	always@ (posedge clk)begin
		if(~rst) state_ <= 2'b0;
		if(rst)begin
			wasReady <= keyReady;
			if (!wasReady&&keyReady) begin
				case (keyCode)
					5'hc:
						begin
							state_ <= 2'b10;//button_left
						end
					5'he: 
						begin
							state_ <= 2'b11;//button_right
						end
					5'h9: 
						begin
							state_ <= 2'b00;//button_up
						end
					5'h11: 
						begin
							state_ <= 2'b01;//button_down
						end
					default: ;
				endcase
			end
			
			if (!wasReady&&ps2_ready) begin
				case (keyboardCode)
					8'h6b:	//keyboard_left
						begin
							state_ <= 2'b10;
						end
					8'h74: 	//keyboard_right
						begin
							state_ <= 2'b11;
						end
					8'h75: 	//keyboard_up
						begin
							state_ <= 2'b00;
						end
					8'h72:	//keyboard_down
						begin
							state_ <= 2'b01;
						end
					default: ;
				endcase
			end
		end
		if(result == 1)begin//crash collision;if direction's turn is permitted,change the direction
			state <= state_;
		end
	end
	
	always@(posedge clkdiv[18])begin
		if (~rst) begin
			PacX <= 10'd320;
			PacY <= 9'd146;
		end
		//result_1 = 0 means reached a wall
		if(result_l != 0)begin
			case(state)//pacman moves according to the state
				2'b10:
					begin
						PacX<=PacX - 10'd1;
					end
				2'b11:
					begin
						PacX<=PacX + 10'd1;
					end
				2'b00:
					begin
						PacY<=PacY - 9'd1;
					end
				2'b01:
					begin
						PacY<=PacY + 9'd1;
					end
			endcase
		end
	end
endmodule
