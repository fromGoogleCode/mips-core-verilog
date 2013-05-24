`include "hw/pc.v"

`timescale 1ns / 1ps


`define STRLEN 32
module pc_tb;

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
	reg CLK, PC_write, Reset_L;
	reg [31:0] npc, startPC;
	reg [7:0] passed;

	// Outputs
    wire [31:0] pc;

	// Instantiate the Unit Under Test (UUT)
    PC PC(
    	.CLK(CLK),
    	.Reset_L(Reset_L),
    	.PC_write(PC_write),
    	.npc(npc),
    	.startPC(startPC),
    	.pc(pc)
    );

	initial begin
		// Initialize Inputs
        CLK=1;
        PC_write=1;
        Reset_L=1;
        npc=32'd5;
        startPC = 32'd10;
		passed = 0;

		// Add stimulus here
		
		//ADD YOUR TEST VECTORS FROM THE PRELAB HERE	
        //AND
        {PC_write, Reset_L} = {1'b1, 1'b0}; #10; CLK=0; #10; CLK=1; #10; passTest(pc, 32'd10, "Reset", passed);
        {PC_write, Reset_L} = {1'b0, 1'b1}; #10; CLK=0; #10; CLK=1; #10; passTest(pc, 32'd10, "Hold", passed);
        {PC_write, Reset_L} = {1'b1, 1'b1}; #10; CLK=0; #10; CLK=1; #10; passTest(pc, 32'd5, "Normal", passed);
        
 
		allPassed(passed, 3);
	end
      
endmodule

