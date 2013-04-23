`ifndef _memory_v_
`define _memory_v_
`endif

`ifndef _data_mem_v_
`include "memory/data_mem.v"
`endif

`ifndef _mem_wb_v_
`include "memory/mem_wb.v"
`endif

module memory(clk,
              MEM_ctlwb, MEM_alu_out, MEM_rd, MEM_ctlm, MEM_alu_zero, MEM_rd2,
              WB_ctlwb, WB_rdata, WB_alu_out, WB_rd, MEM_PCSrc);

  input wire clk;

  input wire [1:0] MEM_ctlwb;
  input wire [31:0] MEM_alu_out;
  input wire [4:0] MEM_rd;
  input wire [2:0] MEM_ctlm;
  input wire MEM_alu_zero;
  input wire [31:0] MEM_rd2;
  
  output wire [1:0] WB_ctlwb;
  output wire [31:0] WB_rdata, WB_alu_out;
  output wire [4:0] WB_rd;
  output wire MEM_PCSrc;
  
  wire [31:0] MEM_rdata;
  wire MEM_branch = MEM_ctlm[2];
  wire MEM_read   = MEM_ctlm[1];
  wire MEM_write  = MEM_ctlm[0];
  
  assign MEM_PCSrc = MEM_branch && MEM_alu_zero;
  
  data_mem data_mem(
  	.clk(clk),
  	.MEM_alu_out(MEM_alu_out),
  	.MEM_rd2(MEM_rd2),
  	.MEM_read(MEM_read),
  	.MEM_write(MEM_write),
  	.MEM_rdata(MEM_rdata)
  );
  
  
  mem_wb mem_wb(
  	.clk(clk),
  	.MEM_ctlwb(MEM_ctlwb),
  	.MEM_rdata(MEM_rdata),
  	.MEM_alu_out(MEM_alu_out),
  	.MEM_rd(MEM_rd),
  	.WB_ctlwb(WB_ctlwb),
  	.WB_rdata(WB_rdata),
  	.WB_alu_out(WB_alu_out),
  	.WB_rd(WB_rd)
  );

endmodule