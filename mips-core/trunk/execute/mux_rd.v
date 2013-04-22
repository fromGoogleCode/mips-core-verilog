`ifndef _mux_rd_v_
`define _mux_rd_v_
`endif

`ifndef _mux2_n_v_
`include "modules/mux2_n.v"
`endif

module mux_rd(EX_rt, EX_rd, EX_rd_mux, EX_reg_dst);

  input wire [4:0] EX_rt, EX_rd;
  input wire EX_reg_dst;
  output wire [4:0] EX_rd_mux;
  
  mux2_n #(5) mux2_n_0(
  	.a(EX_rd),
  	.b(EX_rt),
  	.s(EX_reg_dst),
  	.f(EX_rd_mux)
  );

endmodule