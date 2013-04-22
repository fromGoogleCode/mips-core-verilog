`include "fetch/pc_mod.v"

module pc_mod_tb();

  reg [31:0] a;
  wire [31:0] b;
  reg clk = 0;
  
  pc_mod pc_mod_test(.clk(clk), .npc(a), .PC(b));
  
  always 
    #1 clk = !clk;
  
  initial begin
  
    $dumpfile("test.vcd");
    $dumpvars(0, pc_mod_tb);
  
    a=0;
    #5 a=20;
    #5 a=54356;
    #5 a=333653;
    
  
    #10 $finish;
  end

endmodule