`ifndef _s_extend_v_
`define _s_extend_v_
`endif

module s_extend(imm, ID_imm);

  input wire [15:0] imm;
  output wire [31:0] ID_imm;
  
  assign ID_imm = { {16{imm[15]}} , imm};

endmodule