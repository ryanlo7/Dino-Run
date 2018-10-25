/*module enemy(
	input clk, 
	input rst,
	input obstacle_clk,
   input [7:0] obstacle_num,
	output [9:0] obstacle_h,
	output [9:0] obstacle_v,
	output [5:0] obstacle_hvel, 
   output [7:0] obstacle_height,
   output [7:0] obstacle_width
);

parameter screen_width = 640; // 640??

// initially a pter on ground
reg [7:0] obstacle_height_reg = 30;
reg [7:0] obstacle_width_reg = 60;
reg [9:0] obstacle_h_reg = screen_width + 60; // init obstacle_width
reg [9:0] obstacle_v_reg = 420 - 30; // init obstacle_width
reg [5:0] obstacle_hvel_reg = 5;

assign obstacle_h = obstacle_h_reg;
assign obstacle_v = obstacle_v_reg;
assign obstacle_hvel = obstacle_hvel_reg;
assign obstacle_height = obstacle_height_reg;
assign obstacle_width = obstacle_width_reg;

// FOR OBSTACLES: OBJECT REFERENCE POINT IS UPPER RIGHT CORNER!!!

parameter cactus_height = 80;
parameter cactus_width = 30;
parameter pter_height = 30;
parameter pter_width = 60;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // reset to pter on ground
        obstacle_height_reg <= pter_height;
        obstacle_width_reg <= pter_width;
        obstacle_h_reg <= screen_width + obstacle_width_reg;
        obstacle_v_reg <= 420 - obstacle_height_reg;
    end
	 else begin
    //else if (obstacle_clk) begin
	 
			 obstacle_h_reg <= obstacle_h_reg - obstacle_hvel_reg;
			  
			 if (obstacle_h_reg <= 0) begin
					obstacle_h_reg <= screen_width + obstacle_width_reg;
					
					// choose a random obstacle when resetting
					if(obstacle_num % 3 == 0) begin
						 // cactus
						 obstacle_height_reg <= cactus_height;
						 obstacle_width_reg <= cactus_width;
						 obstacle_v_reg <= 440 - cactus_height;
					end
					else if (obstacle_num % 3 == 1) begin
						 // pter in air
						 obstacle_height_reg <= pter_height;
						 obstacle_width_reg <= pter_width;
						 obstacle_v_reg <= 360 - pter_height;
					end
					else begin
						 // pter on ground
						 obstacle_height_reg <= pter_height;
						 obstacle_width_reg <= pter_width;
						 obstacle_v_reg <= 420 - pter_height;
					end
				
			 end 
        
    end
	
	
end

endmodule
*/


module enemy(
	input clk, 
	input rst,
	input obstacle_clk,
   input [7:0] obstacle_num,
	input [9:0] other_obstacle_h,
	output [9:0] obstacle_h,
	output [9:0] obstacle_v,
	output [5:0] obstacle_hvel, 
   output [7:0] obstacle_height,
   output [7:0] obstacle_width
);

parameter screen_width = 640; // 640??

// initially a pter on ground
reg [7:0] obstacle_height_reg = 30;
reg [7:0] obstacle_width_reg = 60;
reg [9:0] obstacle_h_reg = screen_width + 60; // init obstacle_width
reg [9:0] obstacle_v_reg = 420 - 30; // init obstacle_width
reg [5:0] obstacle_hvel_reg = 5;

reg wait_state_obstacle = 1;
reg wait_state_counter = 1;
reg [7:0] counter = 0;
reg [7:0] current_obstacle_num;


assign obstacle_h = obstacle_h_reg;
assign obstacle_v = obstacle_v_reg;
assign obstacle_hvel = obstacle_hvel_reg;
assign obstacle_height = obstacle_height_reg;
assign obstacle_width = obstacle_width_reg;

// FOR OBSTACLES: OBJECT REFERENCE POINT IS UPPER RIGHT CORNER!!!

parameter cactus_height = 80;
parameter cactus_width = 30;
parameter pter_height = 30;
parameter pter_width = 60;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // reset to pter on ground
        obstacle_height_reg <= pter_height;
        obstacle_width_reg <= pter_width;
        obstacle_h_reg <= screen_width + obstacle_width_reg;
//        obstacle_v_reg <= 420 - obstacle_height_reg; CHANGE BACK TO PTER ON GROUND
			obstacle_v_reg <= 405 - pter_height; // pter in air
		  wait_state_obstacle <= 1;
		  wait_state_counter <= 1;
    end
	 else if (wait_state_obstacle) begin
		obstacle_h_reg <= screen_width + obstacle_width_reg; // hard code
		if (other_obstacle_h <= 320) begin // half of the screen
			wait_state_obstacle <= 0;
			wait_state_counter <= 1;
			current_obstacle_num <= obstacle_num;
			counter <= 0;
		end
	 end 
	 else if (wait_state_counter) begin
		obstacle_h_reg <= screen_width + obstacle_width_reg; // hard code
		if(counter == (current_obstacle_num % 21)) begin // MAKE SURE THAT 20 IS SMALL ENOUGH
			wait_state_counter <= 0;
		end
		else
			counter <= counter + 1;
	 end
	 else begin
    //else if (obstacle_clk) begin
	 
			 obstacle_h_reg <= obstacle_h_reg - obstacle_hvel_reg;
			  
			 if (obstacle_h_reg <= 0) begin
					
					
					// choose a random obstacle when resetting
					if(obstacle_num % 3 == 0) begin
						 // cactus
						 obstacle_height_reg <= cactus_height;
						 obstacle_width_reg <= cactus_width;
						 obstacle_v_reg <= 440 - cactus_height;
					end
					else if (obstacle_num % 3 == 1) begin
						 // pter in air
						 obstacle_height_reg <= pter_height;
						 obstacle_width_reg <= pter_width;
						 obstacle_v_reg <= 405 - pter_height;
					end
					else begin
						 // pter on ground
						 obstacle_height_reg <= pter_height;
						 obstacle_width_reg <= pter_width;
						 obstacle_v_reg <= 435 - pter_height;
					end
					obstacle_h_reg <= screen_width + obstacle_width_reg;
					wait_state_obstacle <= 1;
				
			 end 
        
    end
	
	
end

endmodule
