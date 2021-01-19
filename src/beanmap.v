`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:39:47 12/30/2020 
// Design Name: 
// Module Name:    beanmap 
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

//this part is for display the beans and is already added to the display module.
module beanmap(input [9:0] x, input [8:0] y, input [1199:0]beanmapData, output isbean);
	 
    assign isbean = ((beanmapData[(y/16)*40+(x/16)] == 1 && ((x-(((y/16)*40+(x/16))%40)*16-8)*(x-(((y/16)*40+(x/16))%40)*16-8)+(y-(((y/16)*40+(x/16))/40)*16-8)*(y-(((y/16)*40+(x/16))/40)*16-8)) <= 16))? 1 : 0;

endmodule