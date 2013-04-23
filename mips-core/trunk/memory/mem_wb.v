`ifndef _mem_wb_v_
`define _mem_wb_v_
`endif

module mem_wb(clk,
              MEM_ctlwb, MEM_rdata, MEM_alu_out, MEM_rd,
              WB_ctlwb, WB_rdata, WB_alu_out, WB_rd);

  input wire clk;

  input wire [1:0] MEM_ctlwb;
  input wire [31:0] MEM_rdata, MEM_alu_out;
  input wire [4:0] MEM_rd;
  
  output reg [1:0] WB_ctlwb;
  output reg [31:0] WB_rdata, WB_alu_out;
  output reg [4:0] WB_rd;
  
  initial begin
    WB_ctlwb <= 0;
  end
  
  always @(posedge clk)
  begin
    WB_ctlwb   <= MEM_ctlwb;
    WB_rdata   <= MEM_rdata;
    WB_alu_out <= MEM_alu_out;
    WB_rd      <= MEM_rd;
  end
 
endmodule