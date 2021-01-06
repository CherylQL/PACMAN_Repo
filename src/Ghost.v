module Ghost_M(
    input wire clk,               // Clock
    input wire rst,               // Reset
    output reg [9:0] x,           // X value of Ghost's position 
    output reg [8:0] y,           // Y value of Ghost's position
	 output result,
    output reg [1:0] direction
);

	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk), .rst(rst), .clkdiv(clkdiv));
	CheckCollision cc_turn(.clk(clk), .rst(rst), .PacX(x), .PacY(y), .state(direction), .result(result));

	initial begin
 		direction <= 2'b00;
    	x <= 10'd200;
    	y <= 9'd146;
		
		randomCnt1 <= 2'b01;
		randomCnt2 <= 3'b010;
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

	reg [1:0] randomCnt1;	
	always @ (posedge clkdiv[7]) begin
		randomCnt1 <= randomCnt1 + 1;
	end

	reg [2:0] randomCnt2;	
	always @ (posedge clkdiv[8]) begin
		randomCnt2 <= randomCnt2 + 1;
	end
  
	always @ (posedge clkdiv[9]) begin
	    if(result == 0)
			direction <= randomCnt1 + randomCnt2;
 	end

endmodule