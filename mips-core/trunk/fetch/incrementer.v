`ifndef _incrementer_v_
`define _incrementer_v_
`endif

`ifndef _add32_v_
`include "modules/adder/add32.v"
`endif

module incrementer(pcin, pcout);
  input wire [31:0] pcin;
  output wire [31:0] pcout;

  wire [31:0] b = 32'd1;
  wire cin = 0;
  wire cout;
  
  add32 add32_0 (
        .a(pcin),
        .b(b),
        .cin(cin),
        .s(pcout),
        .cout(cout)
        );

endmodule