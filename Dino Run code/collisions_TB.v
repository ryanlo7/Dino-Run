`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:16:22 11/30/2017
// Design Name:   collisions
// Module Name:   C:/Users/152/Documents/Downloads/NERP_demo-rand-enemy-height/NERP_demo/collisions_TB.v
// Project Name:  NERP_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: collisions
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module collisions_TB;

	// Inputs
	reg [9:0] obstacle_h;
	reg [9:0] obstacle_v;
	reg [9:0] dino_h;
	reg [9:0] dino_v;
	reg [9:0] enemy_h;
	reg [9:0] enemy_v;
	reg clk;
	reg clr;

	// Outputs
	wire is_alive;

	// Instantiate the Unit Under Test (UUT)
	collisions uut (
		.obstacle_h(obstacle_h), 
		.obstacle_v(obstacle_v), 
		.dino_h(dino_h), 
		.dino_v(dino_v), 
		.enemy_h(enemy_h), 
		.enemy_v(enemy_v), 
		.clk(clk), 
		.clr(clr), 
		.is_alive(is_alive)
	);

	initial begin
		// Initialize Inputs
		obstacle_h = 0;
		obstacle_v = 0;
		dino_h = 0;
		dino_v = 320;
		enemy_h = 40;
		enemy_v = 330;
		clk = 0;
		clr = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

