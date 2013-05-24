`include "hw/ForwardingUnit.v"

`timescale 1ns / 1ps


`define STRLEN 32
module ForwardingUnit_tb;


	task passTest;
		input [5:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [7:0] passed;
    reg UseShamt, UseImmed;
    reg [4:0] ID_Rs, ID_Rt, EX_Rw, MEM_Rw;
    reg EX_RegWrite, MEM_RegWrite;
    
	// Outputs
	wire [1:0] AluOpCtrlA, AluOpCtrlB;
    wire DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM;

	// Instantiate the Unit Under Test (UUT)
    ForwardingUnit uut(
    	.UseShamt(UseShamt),
    	.UseImmed(UseImmed),
    	.ID_Rs(ID_Rs),
    	.ID_Rt(ID_Rt),
    	.EX_Rw(EX_Rw),
    	.MEM_Rw(MEM_Rw),
    	.EX_RegWrite(EX_RegWrite),
    	.MEM_RegWrite(MEM_RegWrite),
    	.AluOpCtrlA(AluOpCtrlA),
    	.AluOpCtrlB(AluOpCtrlB),
    	.DataMemForwardCtrl_EX(DataMemForwardCtrl_EX),
    	.DataMemForwardCtrl_MEM(DataMemForwardCtrl_MEM)
    ); 

	initial begin
	    $dumpfile("test.vcd");
	    $dumpvars(0, ForwardingUnit_tb);
		// Initialize Inputs
		passed = 0;

        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd0, 5'd0, 5'd0, 5'd0}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0000; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_00_00_0_0}, "NOP Instruction", passed);
        
        // add R1, R10, R11
        // add R2, R10, R11
        // add R3, R1,  R2
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd1, 5'd2, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0011; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_10_01_0_1}, "ALU Src Test 1", passed);

        // add R1, R10, R11
        // add R2, R10, R11
        // add R3, R2,  R1
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0011; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_01_10_1_0}, "ALU Src Test 2", passed);
 
        // add R1, R10, R11
        // add R1, R10, R11
        // add R3, R2,  R1
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd1, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0011; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_00_01_1_1}, "ALU Src Precedence", passed);
  
        // nop R1, R10, R11
        // nop R2, R10, R11
        // add R3, R2,  R1
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0000; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_00_00_0_0}, "ALU Src nops", passed);
  
  
        // Shift instructions       
  
  
        // add R1, R10, R11
        // add R2, R10, R11
        // sll R3, R2,  #0
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd1, 5'd2, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b1011; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_11_01_0_1}, "Shift: ALU Src Test 1", passed);

        // add R1, R10, R11
        // add R2, R10, R11
        // sll R3, R1,  #0
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b1011; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_11_10_1_0}, "Shift: ALU Src Test 2", passed);
 
        // add R1, R10, R11
        // add R1, R10, R11
        // sll R3, R1,  #0
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd1, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b1011; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_11_01_1_1}, "Shift: ALU Src Precedence", passed);
  
        // nop R1, R10, R11
        // nop R2, R10, R11
        // sll R3, R1,  #0
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b1000; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_11_00_0_0}, "Shift: ALU Src nops", passed);
  
  
        // Immediate functions
        // add  R1, R10, R11
        // add  R2, R10, R11
        // addi R3, R1,  #2
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd1, 5'd2, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0111; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_10_11_0_1}, "ALU Src Test 1", passed);

        // add  R1, R10, R11
        // add  R2, R10, R11
        // addi R3, R2,  #1
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0111; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_01_11_1_0}, "ALU Src Test 2", passed);
 
        // add  R1, R10, R11
        // add  R1, R10, R11
        // addi R3, R2,  #1
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd1, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0111; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_00_11_1_1}, "ALU Src Precedence", passed);
  
        // nop  R1, R10, R11
        // nop  R2, R10, R11
        // addi R3, R2,  #1
        {ID_Rs, ID_Rt, EX_Rw, MEM_Rw} = {5'd2, 5'd1, 5'd2, 5'd1}; {UseShamt, UseImmed, EX_RegWrite, MEM_RegWrite} = 4'b0100; #10 passTest({AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM}, {6'b_00_11_0_0}, "ALU Src nops", passed);
          
        
		
		allPassed(passed, 13);
		$finish;
	end
      
endmodule

