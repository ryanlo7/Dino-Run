`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:31:06 11/03/2017 
// Design Name: 
// Module Name:    seven_digit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module seven_segment(alive, score3, score2, score1, score0, segment_hz, segments, digit_index, blink_hz);
	 
input wire[3:0] score3;
input wire[3:0] score2;
input wire[3:0] score1;
input wire[3:0] score0;
input wire segment_hz;
input wire blink_hz;
input wire alive;

reg [7:0] score3_segments;
reg [7:0] score2_segments;
reg [7:0] score1_segments;
reg [7:0] score0_segments;

reg [1:0] counter = 2'b00;
output reg [7:0] segments;
output reg [3:0] digit_index;

reg [7:0] blank_seg;

always @ (posedge segment_hz) begin
	case (score3)	
		0: score3_segments <= 8'b11000000;	
		1: score3_segments <=  8'b11111001;	
		2: score3_segments <=  8'b10100100;
		3: score3_segments <=  8'b10110000;
		4: score3_segments <=  8'b10011001;
		5: score3_segments <=  8'b10010010;
		6: score3_segments <=  8'b10000010;
		7: score3_segments <= 8'b11111000;
		8: score3_segments <=  8'b10000000;
		9: score3_segments <=  8'b10010000;
		default: score3_segments <= 8'b11111111;
	endcase
	
	case (score2)	
		0: score2_segments <= 8'b11000000;	
		1: score2_segments <=  8'b11111001;	
		2: score2_segments <=  8'b10100100;
		3: score2_segments <=  8'b10110000;
		4: score2_segments <=  8'b10011001;
		5: score2_segments <=  8'b10010010;
		6: score2_segments <=  8'b10000010;
		7: score2_segments <= 8'b11111000;
		8: score2_segments <=  8'b10000000;
		9: score2_segments <=  8'b10010000;
		default: score2_segments <= 8'b11111111;
	endcase
	
	case (score1)	
		0: score1_segments <= 8'b11000000;	
		1: score1_segments <=  8'b11111001;	
		2: score1_segments <=  8'b10100100;
		3: score1_segments <=  8'b10110000;
		4: score1_segments <=  8'b10011001;
		5: score1_segments <=  8'b10010010;
		6: score1_segments <=  8'b10000010;
		7: score1_segments <= 8'b11111000;
		8: score1_segments <=  8'b10000000;
		9: score1_segments <=  8'b10010000;
		default: score1_segments <= 8'b11111111;
	endcase
	
	case (score0)	
		0: score0_segments <= 8'b11000000;	
		1: score0_segments <=  8'b11111001;	
		2: score0_segments <=  8'b10100100;
		3: score0_segments <=  8'b10110000;
		4: score0_segments <=  8'b10011001;
		5: score0_segments <=  8'b10010010;
		6: score0_segments <=  8'b10000010;
		7: score0_segments <= 8'b11111000;
		8: score0_segments <=  8'b10000000;
		9: score0_segments <=  8'b10010000;
		default: score0_segments <= 8'b11111111;
	endcase
	counter <= counter + 1;
	
	if (alive) begin
		case (counter)
			0: begin 
				digit_index <= 4'b0111;
				segments <= score3_segments;
				end
			1: begin
				digit_index <= 4'b1011;
				segments <= score2_segments;
				end
			2: begin
				digit_index <= 4'b1101;
				segments <= score1_segments;
				end
			3: begin
				digit_index <= 4'b1110;
				segments <= score0_segments;
				end
		endcase
	end
	else begin
		case (counter)
			0: begin 
					  if (blink_hz) begin
							digit_index <= 4'b0111;
							segments <= score3_segments;
					  end 
					  else begin
							digit_index <= 4'b1111;
							segments <= blank_seg;
					  end
				end
			1: begin
					  if (blink_hz) begin
							digit_index <= 4'b1011;
							segments <= score2_segments;
					  end
					  else begin
							digit_index <= 4'b1111;
							segments <= blank_seg;
					  end
				end
			2: begin
					if (blink_hz) begin
						digit_index <= 4'b1101;
						segments <= score1_segments;
					end 
					else begin
						digit_index <= 4'b1111;
						segments <= blank_seg;
					end
				end
			3: begin
					if (blink_hz) begin
						digit_index <= 4'b1110;
						segments <= score0_segments;
					end
					else begin
						digit_index <= 4'b1111;
						segments <= blank_seg;
					end
				end
		endcase
	end

//	else if (adj & sel)
//	begin
//		case (counter)
//			0: begin 
//                    if (blink_hz) begin
//                        digit_index <= 4'b0111;
//                        segments <= score3_segments;
//                    end 
//                    else begin
//                        digit_index <= 4'b1111;
//                        segments <= blank_seg;
//                    end
//				end
//			1: begin
//                    if (blink_hz) begin
//                        digit_index <= 4'b1011;
//                        segments <= score2_segments;
//                    end
//                    else begin
//                        digit_index <= 4'b1111;
//                        segments <= blank_seg;
//                    end
//				end
//			2: begin
//				digit_index <= 4'b1101;
//				segments <= score1_segments;
//				end
//			3: begin
//				digit_index <= 4'b1110;
//				segments <= score0_segments;
//				end
//		endcase
//	end
//    else begin
//        case (counter)
//			0: begin 
//				digit_index <= 4'b0111;
//				segments <= score3_segments;
//				end
//			1: begin
//				digit_index <= 4'b1011;
//				segments <= score2_segments;
//				end
//			2: begin
//                    if (blink_hz) begin
//                        digit_index <= 4'b1101;
//                        segments <= score1_segments;
//                    end 
//                    else begin
//                        digit_index <= 4'b1111;
//                        segments <= blank_seg;
//                    end
//				end
//			3: begin
//                    if (blink_hz) begin
//                        digit_index <= 4'b1110;
//                        segments <= score0_segments;
//                    end    
//                    else begin
//                        digit_index <= 4'b1111;
//                        segments <= blank_seg;
//                    end
//				end
//		endcase
//    end
end

endmodule
