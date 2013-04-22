`include "fetch/ifetch.v"
`include "decode/idecode.v"

module idecode_tb();
  
  reg clk = 0;
  reg [31:0] MEM_bpc = 0;
  reg MEM_PCSrc = 0;
  wire [31:0] ID_ir, ID_npc;
  
  reg WB_wen=0;         // Register Write Enable, from MEM_WB regs
  reg [31:0] WB_wdata = 0;// Register Write Data, from WB mux
  reg [4:0] WB_rd = 0;    // Register Write Index, from MEM_WB regs
 
  wire [1:0] EX_ctlwb;
  wire [2:0] EX_ctlm;
  wire [3:0] EX_ctlex;
  wire [31:0] EX_npc, EX_rd1, EX_rd2, EX_imm;
  wire [4:0] EX_rt, EX_rd;  
  
  ifetch ifetch(
    .clk(clk),
    .MEM_bpc(MEM_bpc),
    .MEM_PCSrc(MEM_PCSrc),
    .ID_ir(ID_ir),
    .ID_npc(ID_npc)
  );
  
  idecode idecode(
  	.ID_ir(ID_ir),
  	.ID_npc(ID_npc),
  	.WB_wen(WB_wen),
  	.WB_wdata(WB_wdata),
  	.WB_rd(WB_rd),
  	.clk(clk),
  	.EX_ctlwb(EX_ctlwb),
  	.EX_ctlm(EX_ctlm),
  	.EX_ctlex(EX_ctlex),
  	.EX_npc(EX_npc),
  	.EX_rd1(EX_rd1),
  	.EX_rd2(EX_rd2),
  	.EX_imm(EX_imm),
  	.EX_rt(EX_rt),
  	.EX_rd(EX_rd)
  );

  always
    #1 clk = !clk;
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, idecode_tb);
  
    #22 $finish;
  end

endmodule