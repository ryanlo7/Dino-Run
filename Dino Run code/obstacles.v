module obstacle(
	input clk, 
	input rst,
   input [7:0] obstacle_num,
	input [7:0] obstacle_time,
	output [9:0] obstacle_h,
	output [9:0] obstacle_v,
	output [5:0] obstacle_hvel, 
   output [7:0] obstacle_height,
   output [7:0] obstacle_width
);

parameter screen_width = 640; // 640??

// initially a cactus
reg [7:0] obstacle_height_reg = 80;
reg [7:0] obstacle_width_reg = 30;
reg [9:0] obstacle_h_reg = screen_width + 30; // init obstacle_width
reg [9:0] obstacle_v_reg = 440 - 80; // init obstacle_width
reg [5:0] obstacle_hvel_reg = 5;
reg [7:0] obstacle_counter = 0;
reg wait_state = 1;
reg [7:0] curr_obstacle_time;

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
        // reset to cactus
        obstacle_height_reg <= cactus_height;
        obstacle_width_reg <= cactus_width;
        obstacle_h_reg <= screen_width + obstacle_width_reg;
        obstacle_v_reg <= 440 - obstacle_height_reg;
		  obstacle_counter <= 0;
		  wait_state <= 1;
		  curr_obstacle_time <= obstacle_time;
    end
	 else if (wait_state) begin
		obstacle_h_reg <= screen_width + obstacle_width_reg;	// hard code fix
		obstacle_counter <= obstacle_counter + 1;
		if (obstacle_counter == (curr_obstacle_time % 128)) begin
			obstacle_counter <= 0;
			wait_state <= 0;
		end
	 end
    else if (!wait_state) begin
       obstacle_h_reg <= obstacle_h_reg - obstacle_hvel_reg;		 
		 
		 if (obstacle_h_reg <= 0) begin
            
				wait_state <= 1;
            // choose a random obstacle when resetting
            if(obstacle_num % 3 == 0) begin
                // cactus
                obstacle_height_reg <= cactus_height;
                obstacle_width_reg <= cactus_width;
                obstacle_v_reg <= 440 - cactus_height;
					 obstacle_h_reg <= screen_width + obstacle_width_reg;
            end
            else if (obstacle_num % 3 == 1) begin
                // pter in air
                obstacle_height_reg <= pter_height;
                obstacle_width_reg <= pter_width;
                obstacle_v_reg <= 405 - pter_height;
					 
					 obstacle_h_reg <= screen_width + obstacle_width_reg;
            end
            else begin
                // pter on ground
                obstacle_height_reg <= pter_height;
                obstacle_width_reg <= pter_width;
                obstacle_v_reg <= 435 - pter_height;
					 obstacle_h_reg <= screen_width + obstacle_width_reg;
            end
								
				obstacle_counter <= 0;
				curr_obstacle_time <= obstacle_time;
		 end          
    end
end

endmodule


// old obstacle for cactus
/*module obstacles(
	input clk, 
	input rst,
	output [9:0] obstacle_h,
	output [9:0] obstacle_v,
	output [5:0] obstacle_hvel
);

parameter cactus_height = 80;
parameter cactus_width = 30;

parameter screen_width = 640; // 640??

reg [9:0] obstacle_h_reg = screen_width + cactus_width;
reg [9:0] obstacle_v_reg = 440 - cactus_height;
reg [5:0] obstacle_hvel_reg = 5;

assign obstacle_h = obstacle_h_reg;
assign obstacle_v = obstacle_v_reg;
assign obstacle_hvel = obstacle_hvel_reg;

// FOR OBSTACLES: OBJECT REFERENCE POINT IS UPPER RIGHT CORNER!!!

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        obstacle_h_reg <= screen_width + cactus_width;
        obstacle_v_reg <= 440 - cactus_height;
    end
    else begin
       obstacle_h_reg <= obstacle_h_reg - obstacle_hvel_reg;
        
		 if (obstacle_h_reg <= 0) begin
					obstacle_h_reg <= screen_width + cactus_width;
					obstacle_v_reg <= 440 - cactus_height;
		 end
    end
	
	
end

endmodule*/