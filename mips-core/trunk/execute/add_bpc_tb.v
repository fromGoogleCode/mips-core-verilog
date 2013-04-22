`include "execute/add_bpc.v"

module add_bpc_tb();

  reg [31:0] EX_npc, EX_imm;
  wire [31:0] EX_bpc;
  
  add_bpc add_bpc(
  	.EX_npc(EX_npc),
  	.EX_imm(EX_imm),
  	.EX_bpc(EX_bpc)
  );

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, add_bpc_tb);
    
    EX_npc = 0; EX_imm = 0;
    #5
    EX_npc = 10; EX_imm = 5;
    #5
    EX_npc = 801; EX_imm = 200;
    
    #10 $finish;
  end

endmodule