`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: lookup lfsr random num gen
// source: http://www.asic-world.com/code/hdl_models/lfsr.v
//
//////////////////////////////////////////////////////////////////////////////////
module main(
	input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
	//input wire alive_sel, 			//testing purposes only
	input wire jump, // button press
	
	output wire [7:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync			//vertical sync out
	);

//score
wire [3:0] score3;
wire [3:0] score2;
wire [3:0] score1;
wire [3:0] score0;
wire [1:0] level;	// 12/3

//states
wire clk_final;
//reg alive_state_reg;
wire alive_state;

//initial begin
//	alive_state <= 1;
//end

//clocks
wire two_hz;
wire dino_clk;
wire cactus_clk;
wire obstacle_clk;

// 7-segment clock interconnect
wire segclk;
wire blinkclk;

// VGA display clock interconnect
wire dclk;

// disable the 7-segment decimal points
assign dp = 1;

// dino fields
wire [9:0] dino_h;
wire [9:0] dino_v;
wire [5:0] dino_vvel;
wire jump_state; // whether dino jumping
wire jump_button_state; // button press after debouncer
wire rst_button_state;
/*debouncer block2(
    .button(jump), 
    .clk(clk), 
    .button_state(jump_button_state)
);*/

debouncer block3(
    .button(clr), 
    .clk(clk), 
    .button_state(rst_button_state)
);

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk),
	.two_hz(two_hz),
	.dino_clk(dino_clk),
	.cactus_clk(cactus_clk),
	.blink_hz(blinkclk),
	.obstacle_clk(obstacle_clk),
	.level(level)
	);

//// counter for score
counter block4(
	.rst(clr),
	.alive(alive_state),
	.clk(two_hz),
	.score3(score3), 
	.score2(score2), 
	.score1(score1), 
	.score0(score0),
	.level(level)
);

// update dinosaur's position
dinofields block1(
	.clk(dino_clk),
	.rst(rst_button_state),
	.dino_h(dino_h),
	.dino_v(dino_v),
	.dino_vvel(dino_vvel),
	.jump_state(jump_state), 
    .jump_button_state(jump)
);

wire [7:0] obstacle_num;
wire [7:0] obstacle1_time;
wire [7:0] obstacle2_time;
wire [7:0] obstacle2_counter;

lfsr obstacle_chooser (
    .out(obstacle_num),  // Output of the counter
    .enable(1),  // Enable  for counter
    .clk(cactus_clk),  // clock input
    .reset(rst_button_state)      // reset input
);

lfsr timing_chooser1 (
    .out(obstacle1_time),  // Output of the counter
    .enable(1),  // Enable  for counter
    .clk(cactus_clk),  // clock input
    .reset(rst_button_state)      // reset input
);

lfsr timing_chooser2 (
    .out(obstacle2_time),  // Output of the counter
    .enable(1),  // Enable  for counter
    .clk(cactus_clk),  // clock input
    .reset(rst_button_state)      // reset input
);

wire [7:0] obstacle_height;
wire [7:0] obstacle_width;
wire [7:0] enemy_height;
wire [7:0] enemy_width;

//obstacle fields
wire [9:0] obstacle_h;
wire [9:0] obstacle_v;
wire [5:0] obstacle_hvel;

// obstacle #1
obstacle obstacle1(
	.clk(cactus_clk), 
	.rst(rst_button_state),
	.obstacle_h(obstacle_h),
	.obstacle_v(obstacle_v),
	.obstacle_hvel(obstacle_hvel),
	.obstacle_num(obstacle_num),
	.obstacle_height(obstacle_height),
	.obstacle_width(obstacle_width), 
	.obstacle_time(obstacle1_time)
);

//enemy fields
wire [9:0] enemy_h;
wire [9:0] enemy_v;
wire [5:0] enemy_hvel;

// obstacle #2
enemy obstacle2(
	.clk(cactus_clk), 
	.rst(rst_button_state),
	.obstacle_clk(obstacle_clk),
	.obstacle_h(enemy_h),
	.obstacle_v(enemy_v),
	.obstacle_hvel(enemy_hvel),
   .obstacle_num(obstacle_num),
	.obstacle_height(enemy_height),
	.obstacle_width(enemy_width),
	.other_obstacle_h(obstacle_h)
);

collisions block2 (
   .clr(clr),
	.obstacle_h(obstacle_h),
	.obstacle_v(obstacle_v),
	.dino_h(dino_h),
	.dino_v(dino_v),
	.enemy_h(enemy_h),
	.enemy_v(enemy_v),
	.clk(dclk),
	.is_alive(alive_state),
	.obstacle_height(obstacle_height),
	.obstacle_width(obstacle_width),
	.enemy_height(enemy_height),
	.enemy_width(enemy_width)
);

wire [9:0] cloud_h;
wire [9:0] cloud_v;
wire [5:0] cloud_hvel;

// cloud #1
clouds block6(
	.clk(cactus_clk), 
	.rst(rst_button_state),
	.cloud_h(cloud_h),
	.cloud_v(cloud_v),
	.cloud_hvel(cloud_hvel)
);

// 7-segment display controller
seven_segment block5(
	.alive(alive_state),
	.score3(score3), 
	.score2(score2), 
	.score1(score1), 
	.score0(score0),
	.segment_hz(segclk), 
	.blink_hz(blinkclk),
	.segments(seg), 
	.digit_index(an)
);

//segdisplay U2(
//	.segclk(segclk),
//	.clr(clr),
//	.seg(seg),
//	.an(an)
//	);

// VGA controller
vga640x480 U3(
	.dclk(dclk),
	.clr(clr),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue),
	.dino_h(dino_h),
	.dino_v(dino_v), 
	.obstacle_h(obstacle_h),
	.obstacle_v(obstacle_v),
	.cloud_v(cloud_v),
	.cloud_h(cloud_h),
	.enemy_h(enemy_h),
	.enemy_v(enemy_v),
	.obstacle_height(obstacle_height),
	.obstacle_width(obstacle_width),
	.enemy_height(enemy_height),
	.enemy_width(enemy_width),
	.score3(score3), //add ons start here
	.score2(score2),
	.score1(score1),
	.score0(score0),
	.alive(alive_state) //add ons end here
	);

endmodule
