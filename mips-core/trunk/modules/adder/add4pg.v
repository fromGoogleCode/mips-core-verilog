`ifndef _add4pg_v_
`define _add4pg_v_
`endif

`ifndef _add1pg_v_
`include "modules/adder/add1pg.v"
`endif

`ifndef _pg4_v_
`include "modules/adder/pg4.v"
`endif

module add4pg(a, b, cin, s, PG, GG);
  input [3:0] a,b;
  input cin;
  output [3:0] s;
  output PG, GG;
  
  wire [3:0] a,b;
  wire cin;
  wire [3:0] s;
  wire PG, GG;
  
  wire [3:0] p, g;
  wire [3:1] c;
  
  pg4 pg4_0(
        .cin(cin),
        .c(c),
        .p(p),
        .g(g),
        .PG(PG),
        .GG(GG)
        );
  
  add1pg add1pg_0 (
        .a(a[0]), 
        .b(b[0]), 
        .c(cin), 
        .s(s[0]), 
        .p(p[0]), 
        .g(g[0])
        );

  add1pg add1pg_1 (
        .a(a[1]), 
        .b(b[1]), 
        .c(c[1]), 
        .s(s[1]), 
        .p(p[1]), 
        .g(g[1])
        );
  
  add1pg add1pg_2 (
        .a(a[2]), 
        .b(b[2]), 
        .c(c[2]), 
        .s(s[2]), 
        .p(p[2]), 
        .g(g[2])
        );
  
  add1pg add1pg_3 (
        .a(a[3]), 
        .b(b[3]), 
        .c(c[3]), 
        .s(s[3]), 
        .p(p[3]), 
        .g(g[3])
        );

endmodule