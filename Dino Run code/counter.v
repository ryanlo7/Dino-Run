`timescale 1ns / 1ps
module counter (rst, alive, clk, score3, score2, score1, score0, level);
	input wire rst;
	input wire clk;
	input wire alive;
    
	output wire [1:0] level;	// LEVEL SPEED UP FOR GAME
	output wire [3:0] score3;
	output wire [3:0] score2;
	output wire [3:0] score1;
	output wire [3:0] score0;
	
	reg [3:0] score3_int = 0;
	reg [3:0] score2_int = 0;
	reg [3:0] score1_int = 0;
	reg [3:0] score0_int = 0;
	reg [1:0] level_int;	// LEVEL REGISTER
	    
	assign score3 = score3_int;
	assign score2 = score2_int;
	assign score1 = score1_int;
	assign score0 = score0_int;
	assign level = level_int;

	always @ (posedge clk or posedge rst) begin
	
        if (rst) begin
            score0_int <= 4'b0;
            score1_int <= 4'b0;
            score3_int <= 4'b0;
            score2_int <= 4'b0;
        end
		  else if (!alive) begin
			score0_int <= score0;
            score1_int <= score1;
            score2_int <= score2;
            score3_int <= score3;
		  end
        else begin
				if (score1_int >= 4) begin
					level_int <= 1;
				end
				else begin
					level_int <= 0;
				end
            // count
            if (score0_int == 9) begin
                score0_int <= 0;
                score1_int <= score1 + 1;
					 
					if (score1_int == 9) begin
						 score1_int <= 0;
						 score2_int <= score2 + 1;
					end
					
					if (score2_int == 9) begin
						 score2_int <= 0;
						 score3_int <= score3 + 1;
					end
					
					if (score3_int == 9)
					begin
						 score3_int <= 0;
					end
					 
            end
            else 
            begin
                score0_int <= score0 + 1;
            end
        end

	end
endmodule // end