`ifndef _ifetch_v_
`define _ifetch_v_
`endif

`ifndef _if_id_v_
`include "fetch/if_id.v"
`endif

`ifndef _incrementer_v_
`include "fetch/incrementer.v"
`endif

`ifndef _inst_mem_v_
`include "fetch/inst_mem.v"
`endif

`ifndef _pc_mod_v_
`include "fetch/pc_mod.v"
`endif

`ifndef _pc_mux_v_
`include "fetch/pc_mux.v"
`endif

module ifetch(clk, MEM_bpc, MEM_PCSrc, ID_ir, ID_npc);

  input wire clk;
  input wire [31:0] MEM_bpc;  //branch target address
  input wire MEM_PCSrc;       //branch condition
  output wire [31:0] ID_ir, ID_npc;
  
  wire [31:0] PC;      // PC to be fetched
  wire [31:0] IF_npc;  // Next sequential PC.
  wire [31:0] npc;     // Next PC: either next sequential PC or branch target

  wire [31:0] IF_ir;
  
  pc_mux pc_mux_0(
  	.a(MEM_bpc),
  	.b(IF_npc),
  	.s(MEM_PCSrc),
  	.f(npc)
  );

  pc_mod pc_mod_0(
  	.npc(npc),
  	.PC(PC),
  	.clk(clk)
  );
  
  incrementer incrementer_0(
  	.pcin(PC),
  	.pcout(IF_npc)
  );

  inst_mem inst_mem_0(
  	.addr(PC),
  	.data(IF_ir)
  );
  
  if_id if_id_0(
  	.IF_ir(IF_ir),
  	.IF_npc(IF_npc),
  	.ID_ir(ID_ir),
  	.ID_npc(ID_npc),
  	.clk(clk)
  );
  
endmodule