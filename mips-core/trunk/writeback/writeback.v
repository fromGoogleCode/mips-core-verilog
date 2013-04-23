`ifndef _writeback_v_
`define _writeback_v_
`endif

module writeback(WB_ctlwb, WB_rdata, WB_alu_out, WB_wen, WB_wdata);

  input wire [1:0] WB_ctlwb;
  input wire [31:0] WB_rdata, WB_alu_out;
  
  output wire WB_wen;
  output wire [31:0] WB_wdata;

  wire WB_lw = WB_ctlwb[0];
  
  assign WB_wen = WB_ctlwb[1];
  
  assign WB_wdata = (WB_lw) ? (WB_rdata) : (WB_alu_out);

endmodule