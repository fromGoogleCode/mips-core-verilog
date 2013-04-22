`ifndef _idecode_v_
`define _idecode_v_
`endif

`ifndef _control_v_
`include "decode/control.v"
`endif

`ifndef _id_ex_v_
`include "decode/id_ex.v"
`endif

`ifndef _reg_file_v_
`include "decode/reg_file.v"
`endif

`ifndef _s_extend_v_
`include "decode/s_extend.v"
`endif

module idecode(clk, ID_ir, ID_npc, WB_wen, WB_wdata, WB_rd,
      EX_ctlwb, EX_ctlm, EX_ctlex, EX_npc, EX_rd1, EX_rd2, EX_imm, EX_rt, EX_rd
      );
  input wire [31:0] ID_ir;   // Instruction Registers from IF_ID regs
  input wire [31:0] ID_npc;  // Next program counter from IF_ID regs
  input wire WB_wen;         // Register Write Enable, from MEM_WB regs
  input wire [31:0] WB_wdata;// Register Write Data, from WB mux
  input wire [4:0] WB_rd;    // Register Write Index, from MEM_WB regs
  
  input wire clk;
  
  output wire [1:0] EX_ctlwb;
  output wire [2:0] EX_ctlm;
  output wire [3:0] EX_ctlex;
  output wire [31:0] EX_npc, EX_rd1, EX_rd2, EX_imm;
  output wire [4:0] EX_rt, EX_rd;  
  
  wire [5:0] opcode = ID_ir[31:26];
  wire [4:0] rs = ID_ir[25:21];
  wire [4:0] rt = ID_ir[20:16];
  wire [15:0] imm = ID_ir[15:0];
  wire [4:0] ID_rt = ID_ir[20:16];
  wire [4:0] ID_rd = ID_ir[15:11];
  
  wire [1:0] ID_ctlwb;
  wire [2:0] ID_ctlm;
  wire [3:0] ID_ctlex;
  wire [31:0] ID_rd1;
  wire [31:0] ID_rd2;
  wire [31:0] ID_imm;
  
  control control_0(
  	.opcode(opcode),
  	.ID_ctlwb(ID_ctlwb),
  	.ID_ctlm(ID_ctlm),
  	.ID_ctlex(ID_ctlex)
  );
  
  reg_file reg_file_0(
  	.clk(clk),
  	.WB_wen(WB_wen),
  	.rs(rs),
  	.rt(rt),
  	.WB_rd(WB_rd),
  	.WB_wdata(WB_wdata),
  	.ID_rd1(ID_rd1),
  	.ID_rd2(ID_rd2)
  );
  
  s_extend s_extend_0(
  	.imm(imm),
  	.ID_imm(ID_imm)
  );

  id_ex id_ex_0(
  	.clk(clk),
  	.ID_ctlwb(ID_ctlwb),
  	.ID_ctlm(ID_ctlm),
  	.ID_ctlex(ID_ctlex),
  	.ID_npc(ID_npc),
  	.ID_rd1(ID_rd1),
  	.ID_rd2(ID_rd2),
  	.ID_imm(ID_imm),
  	.ID_rt(ID_rt),
  	.ID_rd(ID_rd),
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
endmodule