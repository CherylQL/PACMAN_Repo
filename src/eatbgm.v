`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:51:42 01/11/2021 
// Design Name: 
// Module Name:    eatbgm 
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
/*
	13'd1000:prediv <= 16'hA648;
	13'd2000:prediv <= 16'h941F;
	13'd3000:prediv <= 16'h8BCF;
	13'd4000:prediv <= 16'h7C90;
	13'd5000:prediv <= 16'h6EFA;
	13'd6000:prediv <= 16'h62DD;
	13'd7000:begin
		prediv <= 16'hBA9E;
		delay <= 13'd0;
		end
	*/
module eatbgm(
		input clk,rst,key,
		output reg beep
	);
	/*parameter do = 47774;
	parameter ri = 42568;
	parameter mi = 37919;
	parameter fa = 35791;
	parameter so = 31888;
	parameter la = 28410;
	parameter xi = 25309;*/
	reg [15:0] cnt;
	reg rkey;
	reg [15:0] prediv;
	reg [15:0] delay;
	initial begin
	rkey <= 0;
	cnt = 16'd0;
	prediv = 16'h6EFA;
	delay = 13'd0;
	end
	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk),.rst(rst),.clkdiv(clkdiv));
		

	always @(posedge clk) begin
	//rkey = 0 means no hit signal
		if (rkey == 1'b0) begin
			rkey <= key;
			beep <= 1'b0;
			delay <= 13'd0;
			cnt <= 16'd0;
			prediv <= 16'h6EFA;
		end
		else begin
			cnt <= cnt + 1'b1;
			
			//each time cnt reach a cycle, invert beep
			if (cnt == prediv) begin
				cnt <= 0;
				beep <= ~beep;
				delay <= delay +1'b1;
				case(delay)
					16'd400:begin
						prediv <= 16'hBA9E;
					end
					16'd800:begin
						prediv <= 16'h6EFA;
					end
					16'd1200:begin
						prediv <= 16'h8BCF;
					end
					16'd1201: rkey <= 0;
					default : prediv <= prediv;
				endcase
			end
		end 
	end
endmodule
