`ifndef _execute_v_
`define _execute_v_
`endif

`ifndef _add_bpc_v_
`include "execute/add_bpc.v"
`endif

`ifndef _alu_control_v_
`include "execute/alu_control.v"
`endif

`ifndef _alu_v_
`include "execute/alu.v"
`endif

`ifndef _ex_mem_v_
`include "execute/ex_mem.v"
`endif

`ifndef _mux_alu_v_
`include "execute/mux_alu.v"
`endif

`ifndef _mux_rd_v_
`include "execute/mux_rd.v"
`endif

module execute(clk,
            EX_ctlwb, EX_ctlm, EX_ctlex, EX_npc, EX_rd1, EX_rd2, EX_imm, EX_rt, EX_rd,
            MEM_bpc, MEM_alu_out, MEM_rd2, MEM_ctlwb, MEM_ctlm, MEM_alu_zero, MEM_rd
            );

  input wire clk;
  
  input wire [1:0] EX_ctlwb;
  input wire [2:0] EX_ctlm;
  input wire [3:0] EX_ctlex;
  input wire [31:0] EX_npc, EX_rd1, EX_rd2, EX_imm;
  input wire [4:0] EX_rt, EX_rd;  

  output wire [31:0] MEM_bpc, MEM_alu_out, MEM_rd2;
  output wire [1:0] MEM_ctlwb;
  output wire [2:0] MEM_ctlm;
  output wire MEM_alu_zero;
  output wire [4:0] MEM_rd;
  
  wire EX_reg_dst = EX_ctlex[3];
  wire [1:0] EX_alu_op  = EX_ctlex[2:1];
  wire EX_alu_src = EX_ctlex[0];
  
  wire [31:0] EX_alu_in2;  // Second operand to ALU. B for ADD, !B for SUB
  
  wire [31:0] EX_bpc;   // Branch target address
  
  wire [31:0] EX_alu_out;
  wire EX_alu_zero;
  
  wire [2:0] EX_alu_select;  // Control signals from ALU_CONTROL
  
  wire [5:0] EX_funct = EX_imm[5:0];
  
  wire [4:0] EX_rd_mux;
  
  // Branch target calculator
  add_bpc add_bpc(
  	.EX_npc(EX_npc),
  	.EX_imm(EX_imm),
  	.EX_bpc(EX_bpc)
  );

  // ALU input 2 mux
  mux_alu mux_alu(
  	.EX_rd2(EX_rd2),
  	.EX_imm(EX_imm),
  	.EX_alu_src(EX_alu_src),
  	.EX_alu_in2(EX_alu_in2)
  );
  
  // ALU
  alu alu(
  	.EX_rd1(EX_rd1),
  	.EX_alu_in2(EX_alu_in2),
  	.EX_alu_select(EX_alu_select),
  	.EX_alu_out(EX_alu_out),
  	.EX_alu_zero(EX_alu_zero)
  );
  
  // ALU Control unit
  alu_control alu_control(
  	.EX_funct(EX_funct),
  	.EX_alu_op(EX_alu_op),
  	.EX_alu_select(EX_alu_select)
  );
  
  // Destination register for register write during WB stage
  mux_rd mux_rd(
  	.EX_rt(EX_rt),
  	.EX_rd(EX_rd),
  	.EX_reg_dst(EX_reg_dst),
  	.EX_rd_mux(EX_rd_mux)
  );
  
  // EX_MEM Pipeline registers
  ex_mem ex_mem(
  	.clk(clk),
  	.EX_bpc(EX_bpc),
  	.EX_alu_out(EX_alu_out),
  	.EX_rd2(EX_rd2),
  	.EX_ctlwb(EX_ctlwb),
  	.EX_ctlm(EX_ctlm),
  	.EX_alu_zero(EX_alu_zero),
  	.EX_rd_mux(EX_rd_mux),
  	.MEM_bpc(MEM_bpc),
  	.MEM_alu_out(MEM_alu_out),
  	.MEM_rd2(MEM_rd2),
  	.MEM_ctlwb(MEM_ctlwb),
  	.MEM_ctlm(MEM_ctlm),
  	.MEM_alu_zero(MEM_alu_zero),
  	.MEM_rd(MEM_rd)
  );
  
endmodule