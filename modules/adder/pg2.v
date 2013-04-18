`ifndef _pg2_v_
`define _pg2_v_
`endif

module pg2(cin,c,p,g);

  input [1:0] p,g;
  input cin;
  output [2:1] c;

  wire [1:0] p,g;
  wire cin;
  wire [2:1] c;
 
  assign c[1] = g[0] | (p[0] & cin);
  assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
 
endmodule