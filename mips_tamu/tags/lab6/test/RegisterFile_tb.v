`include "hw/RegisterFile.v"

module RegisterFile_tb();

  wire [31:0] BusA, BusB;
  reg [31:0] BusW=0;
  reg [4:0] RA=0, RB=0, RW=0;
  reg RegWr = 0;
  reg Clk =0;

  RegisterFile RegisterFile(
  	.BusA(BusA),
  	.BusB(BusB),
  	.BusW(BusW),
  	.RA(RA),
  	.RB(RB),
  	.RW(RW),
  	.RegWr(RegWr),
  	.Clk(Clk)
  );
  
  always
   #1 Clk = !Clk;
   
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, RegisterFile_tb);
  
    // Test write to R0
    #10
    BusW = 1;
    RegWr = 1;
    
    // Test write to R1, R15
    #10
    RegWr = 0;
    #5
    RW = 1;
    RegWr = 1;
    #5
    RW = 15;
    BusW = 15;
    #5
    RegWr = 0;
    #5
    RA = 1;
    RB = 15;
    
    #10 $finish;
  end

endmodule