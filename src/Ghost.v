module Ghost_M(
    input wire clk,               // Clock
    input wire rst,               // Reset
    output reg [9:0] x,           // X value of Ghost's position 
    output reg [8:0] y,           // Y value of Ghost's position
	output result,
    output reg [1:0] direction,
	output wire [1:0] nextDir
);

	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk), .rst(rst), .clkdiv(clkdiv));
	CheckCollision cc_turn(.clk(clk), .rst(rst), .PacX(x), .PacY(y), .state(direction), .result(result));

	reg [1:0] randomDir1 [12:0];
	reg [3:0] randomCnt1;
	
	reg [1:0] randomDir2 [16:0];
	reg [4:0] randomCnt2;

	assign nextDir = randomDir1[randomCnt1] + randomDir2[randomCnt2];
	
	initial begin
		randomCnt1 <= 0;
		randomDir1[0] <= 2'd0;
		randomDir1[1] <= 2'd2;
		randomDir1[2] <= 2'd1;
		randomDir1[3] <= 2'd3;
		randomDir1[4] <= 2'd2;
		randomDir1[5] <= 2'd3;
		randomDir1[6] <= 2'd1;
		randomDir1[7] <= 2'd0;
		randomDir1[8] <= 2'd1;
		randomDir1[9] <= 2'd0;
		randomDir1[10] <= 2'd3;
		randomDir1[11] <= 2'd2;
		randomDir1[12] <= 2'd3;
		
		randomCnt2 <= 0;
		randomDir2[0] <= 2'd1;
		randomDir2[1] <= 2'd3;
		randomDir2[2] <= 2'd2;
		randomDir2[3] <= 2'd0;
		randomDir2[4] <= 2'd1;
		randomDir2[5] <= 2'd2;
		randomDir2[6] <= 2'd0;
		randomDir2[7] <= 2'd3;
		randomDir2[8] <= 2'd0;
		randomDir2[9] <= 2'd2;
		randomDir2[10] <= 2'd3;
		randomDir2[11] <= 2'd1;
		randomDir2[12] <= 2'd3;
		randomDir2[13] <= 2'd1;
		randomDir2[14] <= 2'd0;
		randomDir2[15] <= 2'd2;
		randomDir2[16] <= 2'd3;
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
			
			if(randomCnt1 == 12) randomCnt1 <= 0;
			else randomCnt1 <= randomCnt1 + 1;
			
			if(randomCnt2 == 16) randomCnt2 <= 0;
			else randomCnt2 <= ran
		end
 	end

endmodule