`ifndef _mux4to1_n_v_
`define _mux4to1_n_v_
`endif

module mux4to1_n(i00, i01, i10, i11, sel, out);
  parameter N=1;
  
  input [N-1:0] i00, i01, i10, i11;
  input [1:0] sel;
  output reg [N-1:0] out;
  
  always @(*) begin
    case (sel)
      2'b00:   out = i00;
      2'b01:   out = i01;
      2'b10:   out = i10;
      2'b11:   out = i11;
      default: out = {N{1'bx}};
    endcase
  end
  
endmodule