`ifndef _mux_alu_v_
`define _mux_alu_v_
`endif

module mux_alu(EX_rd2, EX_imm, EX_alu_src, EX_alu_in2);

  input wire [31:0] EX_rd2, EX_imm;
  input wire EX_alu_src;
  
  output wire [31:0] EX_alu_in2;
  
  assign EX_alu_in2 = (EX_alu_src) ? (EX_imm) : (EX_rd2);

endmodule