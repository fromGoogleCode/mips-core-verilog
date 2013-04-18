`ifndef _mux2_n_v_
`define _mux2_n_v_
`endif

module mux2_n(a,b,s,f);
  parameter N=1;
  
  input [N-1:0] a, b;
  input s;
  output [N-1:0] f;
  
  assign f = (s) ? (a) : (b);
endmodule