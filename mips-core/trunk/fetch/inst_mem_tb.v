`include "fetch/inst_mem.v"

module inst_mem_tb();

  reg [31:0] addr;
  wire [31:0] data;
  
  inst_mem inst_mem_0(.addr(addr), .data(data));

  initial begin
    addr = #1 0;
    
  end

  always
    #4 addr = addr + 1;
    
  always @(data)
     $display("%t %m Address: %d  Data: %h", $time, addr, data);
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0,inst_mem_tb);
    
   
  
    #50 $finish;
  end

endmodule