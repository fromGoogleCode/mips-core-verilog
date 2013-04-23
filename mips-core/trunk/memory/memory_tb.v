`include "fetch/ifetch.v"
`include "decode/idecode.v"
`include "execute/execute.v"
`include "memory/memory.v"

module memory_tb();
  
  reg clk = 0;
  wire [31:0] ID_ir, ID_npc;
  
  reg WB_wen=0;         // Register Write Enable, from MEM_WB regs
  reg [31:0] WB_wdata = 0;// Register Write Data, from WB mux
  
  wire [1:0] EX_ctlwb;
  wire [2:0] EX_ctlm;
  wire [3:0] EX_ctlex;
  wire [31:0] EX_npc, EX_rd1, EX_rd2, EX_imm;
  wire [4:0] EX_rt, EX_rd;  
  
  wire [31:0] MEM_bpc, MEM_alu_out, MEM_rd2;
  wire [1:0] MEM_ctlwb;
  wire [2:0] MEM_ctlm;
  wire MEM_alu_zero;
  wire [4:0] MEM_rd;
  
  wire [1:0] WB_ctlwb;
  wire [31:0] WB_rdata, WB_alu_out;
  wire [4:0] WB_rd;
  wire MEM_PCSrc;
  
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

  execute execute(
    .clk(clk),
    .EX_ctlwb(EX_ctlwb),
    .EX_ctlm(EX_ctlm),
    .EX_ctlex(EX_ctlex),
    .EX_npc(EX_npc),
    .EX_rd1(EX_rd1),
    .EX_rd2(EX_rd2),
    .EX_imm(EX_imm),
    .EX_rt(EX_rt),
    .EX_rd(EX_rd),
    .MEM_bpc(MEM_bpc),
    .MEM_alu_out(MEM_alu_out),
    .MEM_rd2(MEM_rd2),
    .MEM_ctlwb(MEM_ctlwb),
    .MEM_ctlm(MEM_ctlm),
    .MEM_alu_zero(MEM_alu_zero),
    .MEM_rd(MEM_rd)
  );

  memory memory(
  	.clk(clk),
  	.MEM_ctlwb(MEM_ctlwb),
  	.MEM_alu_out(MEM_alu_out),
  	.MEM_rd(MEM_rd),
  	.MEM_ctlm(MEM_ctlm),
  	.MEM_alu_zero(MEM_alu_zero),
  	.MEM_rd2(MEM_rd2),
  	.WB_ctlwb(WB_ctlwb),
  	.WB_rdata(WB_rdata),
  	.WB_alu_out(WB_alu_out),
  	.WB_rd(WB_rd),
  	.MEM_PCSrc(MEM_PCSrc)
  );

  always
    #1 clk = !clk;
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, memory_tb);
  
    #22 $finish;
  end

endmodule