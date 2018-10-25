module dinofields(
	input clk, 
	input rst,
   input jump_button_state,
	output [9:0] dino_h,
	output [9:0] dino_v,
	output [5:0] dino_vvel,
	output jump_state
);

parameter gravity = 1;
parameter initial_velocity = 17;
parameter dino_size = 40;

reg [9:0] dino_h_reg = 0;
reg [9:0] dino_v_reg = 440 - dino_size;
reg [5:0] dino_vvel_reg = initial_velocity;
reg v_dir = 1; // 1 for going up = subtract the velocity; 0 = going down = add the velocity
reg is_jump_reg = 0;

assign dino_h = dino_h_reg;
assign dino_v = dino_v_reg;
assign dino_vvel = dino_vvel_reg;
assign jump_state = is_jump_reg;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        dino_v_reg <= 440 - dino_size;
        dino_vvel_reg <= initial_velocity;
        is_jump_reg <= 0;
        v_dir <= 1; 
    end
    else begin
        if (!is_jump_reg && jump_button_state) begin
            is_jump_reg <= 1;
        end
        if (is_jump_reg) begin
            if (v_dir == 1) begin
					 // v_reg is position, vvel_reg is velocity
					 //dino_vvel_reg <= dino_vvel_reg - gravity;
                dino_v_reg <= dino_v_reg - dino_vvel_reg;
					 dino_vvel_reg <= dino_vvel_reg - gravity;
            end
            else begin
					 //dino_vvel_reg <= dino_vvel_reg + gravity;
                dino_v_reg <= dino_v_reg + dino_vvel_reg;
					 dino_vvel_reg <= dino_vvel_reg + gravity;
            end
            
//            if (dino_v_reg <= 230) begin
//					 dino_vvel_reg <= 0;
//                v_dir <= 0;
//            end
				
				if (dino_vvel_reg <= 0 && v_dir == 1) begin
					v_dir <= 0;
					dino_vvel_reg <= 0;
				end
            
            if (dino_v_reg > 440 - dino_size) begin
                v_dir <= 1;
                dino_v_reg <= 440 - dino_size;
                is_jump_reg <= 0;
					 dino_vvel_reg <= initial_velocity;
            end
        end
    end
	
	
end

endmodule
