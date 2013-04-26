`include "execute/ex_mem.v"

module ex_mem_tb();

  reg clk= 0;          
            
  reg [31:0] EX_bpc, EX_alu_out, EX_rd2;
  reg [1:0] EX_ctlwb;
  reg [2:0] EX_ctlm;
  reg EX_alu_zero;
  reg [4:0] EX_rd_mux;
  
  wire [31:0] MEM_bpc, MEM_alu_out, MEM_rd2;
  wire [1:0] MEM_ctlwb;
  wire [2:0] MEM_ctlm;
  wire MEM_alu_zero;
  wire [4:0] MEM_rd;

  ex_mem ex_mem(
  	.clk(clk),
  	.EX_bpc(EX_bpc),
  	.EX_alu_out(EX_alu_out),
  	.EX_rd2(EX_rd2),
  	.EX_ctlwb(EX_ctlwb),
  	.EX_ctlm(EX_ctlm),
  	.EX_alu_zero(EX_alu_zero),
  	.EX_rd_mux(EX_rd_mux),
  	.MEM_bpc(MEM_bpc),
  	.MEM_alu_out(MEM_alu_out),
  	.MEM_rd2(MEM_rd2),
  	.MEM_ctlwb(MEM_ctlwb),
  	.MEM_ctlm(MEM_ctlm),
  	.MEM_alu_zero(MEM_alu_zero),
  	.MEM_rd(MEM_rd)
  );
  
  always
    #1 clk = !clk;
  
  initial begin 
    $dumpfile("test.vcd");
    $dumpvars(0, ex_mem_tb);
    
    #5
    EX_bpc       = 0;
    EX_alu_out   = 0;
    EX_rd2       = 0;
    EX_ctlwb     = 0;
    EX_ctlm      = 0;
    EX_alu_zero  = 0;
    EX_rd_mux    = 0;
    
    #5
    EX_bpc       = 1;
    EX_alu_out   = 2;
    EX_rd2       = 3;
    EX_ctlwb     = 1;
    EX_ctlm      = 5;
    EX_alu_zero  = 1;
    EX_rd_mux    = 6;
    
 
  
    #10 $finish;
  end

endmodule