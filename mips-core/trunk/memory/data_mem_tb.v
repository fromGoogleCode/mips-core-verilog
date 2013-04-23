`include "memory/data_mem.v"

module data_mem_tb();

  reg clk = 0;
  wire [31:0] MEM_alu_out;
  wire [31:0] MEM_rd2;
  reg MEM_read =0;
  reg MEM_write = 0;
  wire [31:0] MEM_rdata;

  reg [3:0] counter = 0;
  
  data_mem data_mem(
  	.clk(clk),
  	.MEM_alu_out(MEM_alu_out),
  	.MEM_rd2(MEM_rd2),
  	.MEM_read(MEM_read),
  	.MEM_write(MEM_write),
  	.MEM_rdata(MEM_rdata)
  );

  always 
    #1 clk = !clk;
    
  always
    #2 counter = counter + 1;
   
  assign MEM_alu_out = {28'b0,counter}; 
  assign MEM_rd2 = {28'b0,counter}; 
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, data_mem_tb);
    
    #32 MEM_write = 1;
    #32 MEM_write = 0;
    
    #36 $finish;
  end
  
endmodule