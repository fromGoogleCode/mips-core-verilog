`include "fetch/ifetch.v"


module ifetch_tb();
  
  reg clk = 0;
  reg [31:0] MEM_bpc = 0;
  reg MEM_PCSrc = 0;
  wire [31:0] ID_ir, ID_npc;
  
  ifetch ifetch(
  	.clk(clk),
  	.MEM_bpc(MEM_bpc),
  	.MEM_PCSrc(MEM_PCSrc),
  	.ID_ir(ID_ir),
  	.ID_npc(ID_npc)
  );

  always
    #1 clk = !clk;
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, ifetch_tb);
  
    #22 $finish;
  end

endmodule