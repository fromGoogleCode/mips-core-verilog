`include "memory/mem_wb.v"

module mem_wb_tb();

  reg clk = 0;

  reg [1:0] MEM_ctlwb = 0;
  reg [31:0] MEM_rdata=0, MEM_alu_out=0;
  reg [4:0] MEM_rd=0;
  
  wire [1:0] WB_ctlwb;
  wire [31:0] WB_rdata, WB_alu_out;
  wire [4:0] WB_rd;
  
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

   always
     #1 clk = !clk;

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, mem_wb_tb);
    
    #5
    MEM_ctlwb = 1;
    MEM_rdata=2;
    MEM_alu_out=3;
    MEM_rd=4;
    
  
    #5 $finish;
  end

endmodule