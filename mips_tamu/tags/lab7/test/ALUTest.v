`include "hw/ALU.v"

`timescale 1ns / 1ps


`define STRLEN 32
module ALUTest_v;

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
	reg [31:0] BusA;
	reg [31:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [31:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

		// Add stimulus here
		
		//ADD YOUR TEST VECTORS FROM THE PRELAB HERE	
        //AND
        {BusA, BusB, ALUCtrl} = {32'hF0F0F0F0, 32'h0000FFFF, `AND}; #40; passTest({Zero, BusW}, 33'h0000F0F0, "AND 0xF0F0F0F0,0x0000FFFF", passed);
        {BusA, BusB, ALUCtrl} = {32'h12345678, 32'h87654321, `AND}; #40; passTest({Zero, BusW}, 33'h02244220, "AND 0x12345678,0x87654321", passed);
        
        //OR
        {BusA, BusB, ALUCtrl} = {32'hF0F0F0F0, 32'h0000FFFF, `OR}; #40; passTest({Zero, BusW}, 33'hF0F0FFFF, "OR 0xF0F0F0F0,0x0000FFFF", passed);
        {BusA, BusB, ALUCtrl} = {32'h12345678, 32'h87654321, `OR}; #40; passTest({Zero, BusW}, 33'h97755779, "OR 0x12345678,0x87654321", passed);
         
        //ADD
        {BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000000, `ADD}; #40; passTest({Zero, BusW}, 33'h100000000, "ADD 0,0", passed);
        {BusA, BusB, ALUCtrl} = {32'h00000000, 32'hFFFFFFFF, `ADD}; #40; passTest({Zero, BusW}, 33'h0FFFFFFFF, "ADD 0,-1", passed);
        {BusA, BusB, ALUCtrl} = {32'hFFFFFFFF, 32'h00000000, `ADD}; #40; passTest({Zero, BusW}, 33'h0FFFFFFFF, "ADD -1,0", passed);
        {BusA, BusB, ALUCtrl} = {32'h000000FF, 32'h00000001, `ADD}; #40; passTest({Zero, BusW}, 33'h000000100, "ADD FF,1", passed);

        //SLL
        {BusA, BusB, ALUCtrl} = {32'd3, 32'h00000001, `SLL}; #40; passTest({Zero, BusW}, 33'h000000008, "SLL 0x00000001,3", passed);
        {BusA, BusB, ALUCtrl} = {32'd6, 32'h00001234, `SLL}; #40; passTest({Zero, BusW}, 33'h000048D00, "SLL 0x00001234,6", passed);
        {BusA, BusB, ALUCtrl} = {32'd6, 32'hFFFF1234, `SLL}; #40; passTest({Zero, BusW}, 33'h0FFC48D00, "SLL 0xFFFF1234,6", passed);

        //SRL
        {BusA, BusB, ALUCtrl} = {32'd3, 32'h00000001, `SRL}; #40; passTest({Zero, BusW}, 33'h100000000, "SRL 0x00000001,3", passed);
        {BusA, BusB, ALUCtrl} = {32'd6, 32'h00001234, `SRL}; #40; passTest({Zero, BusW}, 33'h000000048, "SRL 0x00001234,6", passed);
        {BusA, BusB, ALUCtrl} = {32'd6, 32'hFFFF1234, `SRL}; #40; passTest({Zero, BusW}, 33'h003FFFC48, "SRL 0xFFFF1234,6", passed);

        //SUB
        {BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000000, `SUB}; #40; passTest({Zero, BusW}, 33'h100000000, "SUB 0,0", passed);
        {BusA, BusB, ALUCtrl} = {32'h00000001, 32'hFFFFFFFF, `SUB}; #40; passTest({Zero, BusW}, 33'h000000002, "SUB 1,-1", passed);
        {BusA, BusB, ALUCtrl} = {32'h00000001, 32'h00000001, `SUB}; #40; passTest({Zero, BusW}, 33'h100000000, "SUB 1,1", passed);
        
        //SLT
        {BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000000, `SLT}; #40; passTest({Zero, BusW}, 33'h100000000, "SLT 0,0", passed);
        {BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000001, `SLT}; #40; passTest({Zero, BusW}, 33'h000000001, "SLT 0,1", passed);
        {BusA, BusB, ALUCtrl} = {32'h00000000, 32'hFFFFFFFF, `SLT}; #40; passTest({Zero, BusW}, 33'h000000001, "SLT 0,-1", passed);
        {BusA, BusB, ALUCtrl} = {32'h00000001, 32'h00000000, `SLT}; #40; passTest({Zero, BusW}, 33'h100000000, "SLT 1,0", passed);
        {BusA, BusB, ALUCtrl} = {32'hFFFFFFFF, 32'h00000000, `SLT}; #40; passTest({Zero, BusW}, 33'h100000000, "SLT -1,0", passed);
        
		
		// END PRELAB VECTORS
        // 22 vectors below
		{BusA, BusB, ALUCtrl} = {32'd6, 32'hFFFF1234, 4'd4}; #40; passTest({Zero, BusW}, 33'h003FFFC48, "SRL 0xFFFF1234,6", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000000, 4'd8}; #40; passTest({Zero, BusW}, 33'h100000000, "ADDU 0,0", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000000, 32'hFFFFFFFF, 4'd8}; #40; passTest({Zero, BusW}, 33'h0FFFFFFFF, "ADDU 0,-1", passed);
		{BusA, BusB, ALUCtrl} = {32'hFFFFFFFF, 32'h00000000, 4'd8}; #40; passTest({Zero, BusW}, 33'h0FFFFFFFF, "ADDU -1,0", passed);
		{BusA, BusB, ALUCtrl} = {32'h000000FF, 32'h00000001, 4'd8}; #40; passTest({Zero, BusW}, 33'h000000100, "ADDU FF,1", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000000, 4'd9}; #40; passTest({Zero, BusW}, 33'h100000000, "SUBU 0,0", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000001, 32'hFFFFFFFF, 4'd9}; #40; passTest({Zero, BusW}, 33'h000000002, "SUBU 1,-1", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000001, 32'h00000001, 4'd9}; #40; passTest({Zero, BusW}, 33'h100000000, "SUBU 1,1", passed);
		{BusA, BusB, ALUCtrl} = {32'hF0F0F0F0, 32'h0000FFFF, 4'd10}; #40; passTest({Zero, BusW}, 33'h0F0F00F0F, "XOR 0xF0F0F0F0,0x0000FFFF", passed);
		{BusA, BusB, ALUCtrl} = {32'h12345678, 32'h87654321, 4'd10}; #40; passTest({Zero, BusW}, 33'h095511559, "XOR 0x12345678,0x87654321", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000000, 4'd11}; #40; passTest({Zero, BusW}, 33'h100000000, "SLTU 0,0", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000000, 32'h00000001, 4'd11}; #40; passTest({Zero, BusW}, 33'h000000001, "SLTU 0,1", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000000, 32'hFFFFFFFF, 4'd11}; #40; passTest({Zero, BusW}, 33'h000000001, "SLTU 0,-1", passed);
		{BusA, BusB, ALUCtrl} = {32'h00000001, 32'h00000000, 4'd11}; #40; passTest({Zero, BusW}, 33'h100000000, "SLTU 1,0", passed);
		{BusA, BusB, ALUCtrl} = {32'hFFFFFFFF, 32'h00000000, 4'd11}; #40; passTest({Zero, BusW}, 33'h100000000, "SLTU -1,0", passed);
		{BusA, BusB, ALUCtrl} = {32'hF0F0F0F0, 32'h0000FFFF, 4'd12}; #40; passTest({Zero, BusW}, 33'h00F0F0000, "NOR 0xF0F0F0F0,0x0000FFFF", passed);
		{BusA, BusB, ALUCtrl} = {32'h12345678, 32'h87654321, 4'd12}; #40; passTest({Zero, BusW}, 33'h0688aa886, "NOR 0x12345678,0x87654321", passed);
		{BusA, BusB, ALUCtrl} = {32'd3, 32'h00000001, 4'd13}; #40; passTest({Zero, BusW}, 33'h100000000, "SRA 0x00000001,3", passed);
		{BusA, BusB, ALUCtrl} = {32'd6, 32'h00001234, 4'd13}; #40; passTest({Zero, BusW}, 33'h000000048, "SRA 0x00001234,6", passed);
		{BusA, BusB, ALUCtrl} = {32'd6, 32'hFFFF1234, 4'd13}; #40; passTest({Zero, BusW}, 33'h0FFFFFC48, "SRA 0xFFFF1234,6", passed);
		{BusA, BusB, ALUCtrl} = {32'h0, 32'h12345678, 4'd14}; #40; passTest({Zero, BusW}, 33'h056780000, "LUI 0x12345678", passed);
		{BusA, BusB, ALUCtrl} = {32'h0, 32'h00001234, 4'd14}; #40; passTest({Zero, BusW}, 33'h012340000, "LUI 0x00001234", passed);

		allPassed(passed, 44);
	end
      
endmodule

