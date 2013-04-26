`ifndef _add32_v_
`define _add32_v_
`endif

`ifndef _add16pg_v_
`include "modules/adder/add16pg.v"
`endif

`ifndef _pg2_v_
`include "modules/adder/pg2.v"
`endif

module add32(a, b, cin, s, cout);

  input [31:0] a,b;
  input cin;
  output [31:0] s;
  output cout;    // may change to Overflow/Underflow

  wire [31:0] a,b;
  wire c;
  wire [31:0] s;
  wire cout;    // may change to Overflow/Underflow
  
  wire [1:0] p,g;
  wire c1;

  pg2 pg2_0(
        .cin(cin),
        .c({cout,c1}),
        .p(p),
        .g(g));

  add16pg add16pg_0(
        .a(a[15:0]), 
        .b(b[15:0]), 
        .cin(cin), 
        .s(s[15:0]), 
        .PG(p[0]), 
        .GG(g[0])
        );

  add16pg add16pg_1(
        .a(a[31:16]), 
        .b(b[31:16]), 
        .cin(c1), 
        .s(s[31:16]), 
        .PG(p[1]), 
        .GG(g[1])
        );

endmodule