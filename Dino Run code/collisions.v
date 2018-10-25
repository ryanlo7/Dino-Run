module collisions(
		input [9:0] obstacle_h, 
		input [9:0] obstacle_v, 
		input [9:0] dino_h, 
		input [9:0] dino_v,
		input [9:0] enemy_h,
		input [9:0] enemy_v,
		input clk,
      input clr,
		input [7:0] obstacle_height,
		input [7:0] obstacle_width,
		input [7:0] enemy_height,
		input [7:0] enemy_width,
		output is_alive
	 );

parameter dino_size = 40;

reg [9:0] obstacle_h_shift;
reg [9:0] enemy_h_shift;
reg alive = 1;
assign is_alive = alive;

parameter buffer = 80;
parameter collision_buffer = 0;

always @ (posedge clk or posedge clr) begin
    if (clr == 1) 
        alive <= 1;
    else if (alive == 1) begin
        obstacle_h_shift <= obstacle_h + buffer - obstacle_width;
		  enemy_h_shift <= enemy_h + buffer - enemy_width;

        if (((dino_h + collision_buffer > obstacle_h) || (dino_h + dino_size + buffer < obstacle_h_shift + collision_buffer) 
             || (dino_v + dino_size < obstacle_v + collision_buffer) || (dino_v + collision_buffer > obstacle_v + obstacle_height)) 
             && ((dino_h + collision_buffer > enemy_h) || (dino_h + dino_size + buffer < enemy_h_shift + collision_buffer) 
             || (dino_v + dino_size < enemy_v + collision_buffer) || (dino_v + collision_buffer > enemy_v + enemy_height)))
             alive <= 1;
			else
             alive <= 0;
				 
             
		 
    end
    else
        alive <= 0;
end



endmodule
