`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
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
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input [9:0] dino_h,
	input [9:0] dino_v,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue,	//blue vga output
	input [9:0] obstacle_h,
	input [9:0] obstacle_v,
	input [9:0] cloud_v,
	input [9:0] cloud_h,
	input [9:0] enemy_h,
	input [9:0] enemy_v,
	input [7:0] obstacle_height,
	input [7:0] obstacle_width,
	input [7:0] enemy_height,
	input [7:0] enemy_width,
	input [3:0] score3, //add ons start here
	input [3:0] score2,
	input [3:0] score1,
	input [3:0] score0,
	input alive //add ons end here
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// dino constants
parameter dino_size = 40;
parameter cloud_height = 30;
parameter cloud_width = 80;

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	if (alive == 1) begin
		if (hc <= hfp && hc >= hbp && vc <= vfp && vc >= vbp) begin
			// ground first
			if (vc > vfp - 40 && vc < vfp && hc > hbp && hc < hfp) begin
				red = 3'b011;
				green = 3'b001;
				blue = 2'b00;
			end
			
			// else if (vc >= (vbp + obstacle_v) && vc < (vbp + obstacle_v + obstacle_size))
			// dino display
			else // vbp is top increaseing down to vfp
			begin
				// now display different colors every 80 pixels
				// while we're within the active horizontal range
				
				// -----------------
				// display green bar
				if (vc > (vbp + dino_v) && vc < (vbp + dino_v + dino_size) && hc > hbp && hc < (hbp+dino_size))
				begin
					red = 3'b111;
					green = 3'b000;
					blue = 2'b00;
				end
				else if (vc >= (vbp + obstacle_v) && vc <= (vbp + obstacle_v + obstacle_height) && hc <= obstacle_h+hbp && hc >= (obstacle_h+hbp - obstacle_width)) begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b01;
				end
				else if (vc > (vbp + cloud_v) && vc < (vbp + cloud_v + cloud_height) && hc < cloud_h + hbp && hc > (cloud_h + hbp - cloud_width)) begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
				  else if (vc >= (vbp + enemy_v) && vc <= (vbp + enemy_v + enemy_height) && hc <= enemy_h + hbp && hc >= (enemy_h + hbp - enemy_width)) begin
					red = 3'b000;
					green = 3'b111;
					blue = 2'b01;
				end
				// we're outside active horizontal range so display black
				/*else if (vc >= (vbp + dino_v) && vc < (vbp + dino_v + dino_size))
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
				*/
				// we're outside active vertical range so display black
				else 
				begin
					red = 3'b000;
					green = 3'b000;
					blue = 2'b00;
				end
			end
		end
	end
	else begin
		
		//else 
		//begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		//end
	end
end

endmodule
