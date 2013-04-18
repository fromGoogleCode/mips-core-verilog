`ifndef _pg4_v_
`define _pg4_v_
`endif

module pg4(cin,c,p,g,PG,GG);

  input [3:0] p,g;
  input cin;
  output [3:1] c;
  output PG,GG;

  wire [3:0] p,g;
  wire cin;
  wire [3:1] c;
  wire PG,GG;

  assign c[1] = g[0] | (p[0] & cin);
  assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
  assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
  //assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
  //              (p[3] & p[2] & p[1] & p[0] & cin);
  
  assign PG = p[3] & p[2] & p[1] & p[0]; 
  assign GG = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule