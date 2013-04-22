`ifndef _pc_mux_v_
`define _pc_mux_v_
`endif

`ifndef _mux2_n_v_
`include "modules/mux2_n.v"
`endif

module pc_mux(a,b,s,f);
  
  input [31:0] a,b;
  input s;
  output [31:0] f;
  
  mux2_n #(32) mux2_32(.a(a), .b(b), .s(s), .f(f));


endmodule