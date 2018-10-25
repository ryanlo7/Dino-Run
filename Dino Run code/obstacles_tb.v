`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:56:10 11/21/2017
// Design Name:   obstacles
// Module Name:   C:/Users/152/Downloads/ramya-zip/proj-4-combo/proj-4-combo/NERP_demo/obstacles_tb.v
// Project Name:  NERP_demo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: obstacles
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module obstacles_tb;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [9:0] obstacle_h;
	wire [9:0] obstacle_v;
	wire [5:0] obstacle_hvel;

	// Instantiate the Unit Under Test (UUT)
	obstacles uut (
		.clk(clk), 
		.rst(rst), 
		.obstacle_h(obstacle_h), 
		.obstacle_v(obstacle_v), 
		.obstacle_hvel(obstacle_hvel)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always #10 begin
		clk = ~clk;
	end
endmodule

