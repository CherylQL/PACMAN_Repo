module Ghost_M(
    input wire clk,               // Clock
    input wire rst,               // Reset
    output reg [9:0] x,           // X value of Ghost's position 
    output reg [8:0] y,           // Y value of Ghost's position
    output reg [1:0] direction    // Current Direction of Ghost, 00: up, 01: rihgt, 10: down, 11: left
);

	wire [31:0] clkdiv;
	clkdiv c0(.clk(clk), .rst(rst), .clkdiv(clkdiv));

  CheckCollision cc_turn(.clk(clk), .rst(rst), .PacX(x), .PacY(y), .state(direction), .result(result));

  // Initialize Position
  initial begin
    direction <= 2'b00; 
    x <= 10'd200;
    y <= 9'd146;
  end

	always@(posedge clkdiv[18])begin
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
  
  reg nextRandomDir;

  always @ (posedge clk) begin
    nextRandomDir <= $random % 2;
    if(result == 0) begin
      case(direction)
        2'b00:
          direction = (nextRandomDir == 1'b0 ? 2'b01 : 2'b10);
        2'b01:  
          direction = (nextRandomDir == 1'b0 ? 2'b10 : 2'b11);
        2'b10:
          direction = (nextRandomDir == 1'b0 ? 2'b01 : 2'b11);
        2'b11: 
          direction = (nextRandomDir == 1'b0 ? 2'b00 : 2'b01);
      endcase
    end 
  end

endmodule