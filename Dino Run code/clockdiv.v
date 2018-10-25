`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:36 03/19/2013 
// Design Name: 
// Module Name:    clockdiv 
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
module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk,	//7-segment clock: 381.47Hz
	output wire two_hz,	//two-hz clock
	output wire dino_clk,
	output wire cactus_clk,
	output wire blink_hz,
	output wire obstacle_clk,
	input [1:0] level
	);

// 26-bit counter variable to 27bit
reg [26:0] q;
reg [30:0] p;
reg cactus_clk_reg = 0;


// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr)
begin
	// reset condition
	if (clr == 1) begin
		q <= 0;
		p <= 0;
	end
	// increment counter by one
	else begin
		q <= q + 1;
		p <= p + 1;
	end
end

// 50Mhz ÷ 2^17 = 381.47Hz
assign segclk = q[17];

// 50Mhz ÷ 2^1 = 25MHz
assign dclk = q[1];

// 50Mhz ÷ 2^24 ~ 2.98Hz
assign two_hz = q[24];

// 50Mhz / 
assign dino_clk = q[21];

always @ (*) begin
	if (level == 0) begin
		cactus_clk_reg <= q[21];
	end
	else if (level == 1) begin
		cactus_clk_reg <= q[20];
	end
end	

assign cactus_clk = cactus_clk_reg;

// Slow blink frequency
assign blink_hz = q[25];

// 50Mhz / 2^28 ~ 0.19Hz
assign obstacle_clk = p[30];

endmodule
