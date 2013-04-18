`ifndef _add1pg_v_
`define _add1pg_v_
`endif

module add1pg(a, b, c, s, p, g);

  input a, b, c;
  output s, p, g;
  
  wire a, b, c, s, p , g;

  assign p = a ^ b;
  assign g = a && b;
  assign s = p ^ c;
endmodule