`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:02:57 12/29/2020 
// Design Name: 
// Module Name:    bean 
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

//this part is to eat beans and calculate scores, it hasn't added to any module,
//and it needs a initial score 0 and a initial reg [1199:0]beans to get the beans information from the beanmap output .bmap()
module bean(input [9:0]pac_x,
				input [8:0]pac_y,
				inout [8:0]score,             //socre that input from extrenal (to store the socre in case initial it to 0 every call)
				input [1199:0]beans,          //here to input the beans reg
				output  [8:0]nwescore         //output the new score
    );
	wire [9:0]x;
	wire [8:0]y;
	initial begin
		x = pac_x;
		y = pac_y;
		newscore = socre;
	end
	always@(*) begin
		if(x <= pac_x + 32 && y <= pac_y + 32)begin 
			if(beans[(y / 4) * 160 + (x / 4)]) begin
				beans[(y / 4) * 160 + (x / 4)] <= 0;
				score <= score+1'b1;
			end
			x = x+1'b1;
			y = y+1'b1;
		end
	end

endmodule
