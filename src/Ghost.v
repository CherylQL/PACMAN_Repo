module Ghost_M(
    input wire clk,               // Clock
    input wire [9:0] initX,       // X of Ghost's initial position
    input wire [8:0] initY,       // Y of Ghost's initial position
    output reg [9:0] x,           // X value of Ghost's position 
    output reg [8:0] y,           // Y value of Ghost's position
    output reg [1:0] direction    // Current Direction of Ghost, 00: up, 01: rihgt, 10: down, 11: left
);

    reg [9:0] checkMapX;
    reg [8:0] checkMapY;
    wire checkMapResult;
    Map map(.x(checkMapX), .y(checkMapY), .isWall(checkMapResult));

    // Initialize Position
    initial begin
      direction <= 2'b00; 
      x <= initX;
      y <= initY;
    end

    reg nextRandomDir;

    // Go to next position when clk posedge
	 /*
    always @ (posedge clk) begin
      nextRandomDir <= $random % 2;
      
      case(direction)
        
         // Up
         2'b00: begin
           checkMapX <= x;
           checkMapY <= y - 9'b1;
           if(checkMapResult == 1) direction = (nextRandomDir == 1'b0 ? 2'b01 : 2'b10);
           else y <= y - 9'b1;
         end
        
         // Right
         2'b01: begin
           checkMapX <= x + 10'b1 ;
           checkMapY <= y;
           if(checkMapResult == 1) direction = (nextRandomDir == 1'b0 ? 2'b10 : 2'b11);
           else x <= x + 9'b1;
         end
        
         // Down
         2'b10: begin
           checkMapX <= x;
           checkMapY <= y + 9'b1;
           if(checkMapResult == 1) direction = (nextRandomDir == 1'b0 ? 2'b01 : 2'b11);
           else y <= y + 9'b1;
         end
        
         // Left
         2'b11: begin
           checkMapX <= x - 9'b1;
           checkMapY <= y;
           if(checkMapResult == 1) direction = (nextRandomDir == 1'b0 ? 2'b00 : 2'b01);
           else x <= x - 9'b1;
         end
      
      endcase
    end
	 */

endmodule