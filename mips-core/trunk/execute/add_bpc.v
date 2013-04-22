`ifndef _add_bpc_v_
`define _add_bpc_v_
`endif

`ifndef _add32_v_
`include "modules/adder/add32.v"
`endif

module add_bpc(EX_npc, EX_imm, EX_bpc);
  input wire [31:0] EX_npc, EX_imm;
  output wire [31:0] EX_bpc;
  
  wire cout;
  wire cin = 0;

  add32 add32(
  	.a(EX_npc),
  	.b(EX_imm),
  	.cin(cin),
  	.s(EX_bpc),
  	.cout(cout)
  );

endmodule