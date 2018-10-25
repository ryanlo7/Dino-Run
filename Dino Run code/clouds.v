module clouds(
	input clk, 
	input rst,
	output [9:0] cloud_h,
	output [9:0] cloud_v,
	output [5:0] cloud_hvel
);

parameter cloud_height = 30;
parameter cloud_width = 80;

parameter screen_width = 640; // 640??

reg [9:0] cloud_h_reg = screen_width + cloud_width;
reg [9:0] cloud_v_reg = 200 - cloud_height;
reg [5:0] cloud_hvel_reg = 5;

assign cloud_h = cloud_h_reg;
assign cloud_v = cloud_v_reg;
assign cloud_hvel = cloud_hvel_reg;

// FOR CLOUDS: OBJECT REFERENCE POINT IS UPPER RIGHT CORNER!!!

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        cloud_h_reg <= screen_width + cloud_width;
        cloud_v_reg <= 200 - cloud_height;
    end
    else begin
       cloud_h_reg <= cloud_h_reg - cloud_hvel_reg;
        
		 if (cloud_h_reg <= 0) begin
					cloud_h_reg <= screen_width + cloud_width;
					cloud_v_reg <= 200 - cloud_height;
		 end
    end
	
	
end

endmodule
