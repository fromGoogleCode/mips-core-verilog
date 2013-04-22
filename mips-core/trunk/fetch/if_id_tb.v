`include "fetch/if_id.v"

module if_id_tb();

  reg [31:0] IF_ir, IF_npc;
  wire [31:0] ID_ir, ID_npc;
  reg clk = 0;
  
  if_id IF_ID_0(
  	.IF_ir(IF_ir),
  	.IF_npc(IF_npc),
  	.ID_ir(ID_ir),
  	.ID_npc(ID_npc),
  	.clk(clk)
  );
  
  always 
    #1 clk = !clk;
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, if_id_tb);
    
    IF_ir <= 0; IF_npc <=0;
    #4 IF_ir <= 2; IF_npc <=3;
    #4 IF_ir <= 40; IF_npc <=60;
    #4 IF_ir <= 800; IF_npc <=900;
    
  
  
    #10 $finish;
  end


endmodule