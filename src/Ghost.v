module Ghost_M(
    input wire clk,               // Clock
    input wire rst,               // Reset
    output reg [9:0] x,           // X value of Ghost's position 
    output reg [8:0] y,           // Y value of Ghost's position
	output result,
    output reg [1:0] direction,
	output wire [1:0] nextDir;
);

	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk), .rst(rst), .clkdiv(clkdiv));
	CheckCollision cc_turn(.clk(clk), .rst(rst), .PacX(x), .PacY(y), .state(direction), .result(result));

	reg [1:0] randomDir [15:0];
	reg [3:0] randomCnt;
	
	assign nextDir = randomDir[randomCnt];
	
	initial begin
		randomCnt <= 2'd0;
		randomDir[0] <= 2'd0;
		randomDir[1] <= 2'd2;
		randomDir[2] <= 2'd1;
		randomDir[3] <= 2'd3;
		randomDir[4] <= 2'd2;
		randomDir[5] <= 2'd3;
		randomDir[6] <= 2'd1;
		randomDir[7] <= 2'd0;
		randomDir[8] <= 2'd1;
		randomDir[9] <= 2'd0;
		randomDir[10] <= 2'd3;
		randomDir[11] <= 2'd2;
		randomDir[12] <= 2'd3;
		randomDir[13] <= 2'd1;
		randomDir[14] <= 2'd2;
		randomDir[15] <= 2'd0;
	end
	
	initial begin
    	x <= 10'd200;
    	y <= 9'd146;
 		direction <= 2'b00;
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
	    if(result == 0) begin
			direction <= nextDir;
			randomCnt <= randomCnt + 1;
		end
 	end

endmodule