`ifndef _add16pg_v_
`define _add16pg_v_
`endif

`ifndef _add4pg_v_
`include "add4pg.v"
`endif

`ifndef _pg4_v_
`include "pg4.v"
`endif

module add16pg(a, b, cin, s, PG, GG);
  input [15:0] a,b;
  input cin;
  output [15:0] s;
  output PG, GG;
  
  wire [15:0] a,b;
  wire cin;
  wire [15:0] s;
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
  
  add4pg add4pg_0(
        .a(a[3:0]), 
        .b(b[3:0]), 
        .cin(cin), 
        .s(s[3:0]), 
        .PG(p[0]), 
        .GG(g[0])
        );
 
  add4pg add4pg_1(
        .a(a[7:4]), 
        .b(b[7:4]), 
        .cin(c[1]), 
        .s(s[7:4]), 
        .PG(p[1]), 
        .GG(g[1])
        );

  add4pg add4pg_2(
        .a(a[11:8]), 
        .b(b[11:8]), 
        .cin(c[2]), 
        .s(s[11:8]), 
        .PG(p[2]), 
        .GG(g[2])
        );

  add4pg add4pg_3(
        .a(a[15:12]), 
        .b(b[15:12]), 
        .cin(c[3]), 
        .s(s[15:12]), 
        .PG(p[3]), 
        .GG(g[3])
        );

endmodule