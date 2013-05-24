`include "hw/mux4to1_n.v"

`timescale 1ns / 1ps


`define STRLEN 32
module mux4to1_n_tb;

	task passTest;
		input [32:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [31:0] i00, i01, i10, i11;
	reg [1:0] sel;
	reg [7:0] passed;

	// Outputs
    wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
    mux4to1_n #(32) mux4to1_n(
    	.i00(i00),
    	.i01(i01),
    	.i10(i10),
    	.i11(i11),
    	.sel(sel),
    	.out(out)
    );

	initial begin
		// Initialize Inputs
		i00 = 5;
		i01 = 10;
		i10 = 15;
		i11 = 20;
		sel = 0;
		passed = 0;

		// Add stimulus here
		
		//ADD YOUR TEST VECTORS FROM THE PRELAB HERE	
        //AND
        {sel} = {2'b00}; #40; passTest(out, 32'd5, "sel 0", passed);
        {sel} = {2'b01}; #40; passTest(out, 32'd10, "sel 1", passed);
        {sel} = {2'b10}; #40; passTest(out, 32'd15, "sel 2", passed);
        {sel} = {2'b11}; #40; passTest(out, 32'd20, "sel 3", passed);
 
		allPassed(passed, 4);
	end
      
endmodule

