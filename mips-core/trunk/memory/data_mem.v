`ifndef _data_mem_v_
`define _data_mem_v_
`endif

module data_mem(clk, MEM_alu_out, MEM_rdata, MEM_rd2, MEM_read, MEM_write);

  input wire clk;
  input wire [31:0] MEM_alu_out, MEM_rd2;
  input wire MEM_read, MEM_write;
  
  output wire [31:0] MEM_rdata; 

  reg [31:0] data [255:0];
  
  wire [7:0] addr = MEM_alu_out[7:0];
  
  assign MEM_rdata = data[addr];
  
  always @(posedge clk) begin
    if (MEM_write) data[addr] <= MEM_rd2;
  end
  
  
  // Initial values for lab 4 test
  /*
  initial begin
    data[0] <= 32'h002300AA;
    data[1] <= 32'h10654321;
    data[2] <= 32'h00100022;
    data[3] <= 32'h8C123456;
    data[4] <= 32'h8F123456;
    data[5] <= 32'hAD654321;
    data[6] <= 32'h13012345;
    data[7] <= 32'hAC654321;
    data[8] <= 32'h12012345;
  end
  */
  
  // Initial values for final test
  initial begin
    data[0] <= 0;
    data[1] <= 1;
    data[2] <= 2;
    data[3] <= 3;
    data[4] <= 4;
    data[5] <= 5;
    
  end
endmodule