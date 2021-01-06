module Ghost_M(
    input wire clk,               // Clock
    input wire rst,               // Reset
    output reg [9:0] x,           // X value of Ghost's position 
    output reg [8:0] y,           // Y value of Ghost's position
	 output result,
    output reg [1:0] direction,
	 output reg [1:0] nextDir
);

	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk), .rst(rst), .clkdiv(clkdiv));
	CheckCollision cc_turn(.clk(clk), .rst(rst), .PacX(x), .PacY(y), .state(direction), .result(result));

	initial begin
 		direction <= 2'b00;
		nextDir <= 2'b01;
    	x <= 10'd200;
    	y <= 9'd146;
  	end

	always@(posedge clkdiv[17])begin
		if(result != 0)begin
			case(direction)
				2'b10:
					x <= x - 10'd1;
				2'b11:
					x <= x + 10'd1;
				2'b00:
					y <= y - 9'd1;
				2'b01:
					y <= y + 9'd1;
			endcase
		end
	end
  
	always @ (posedge clkdiv[9]) begin
		nextDir <= nextDir + 1;
	    if(result == 0)
			direction <= nextDir;
 	end

endmodule