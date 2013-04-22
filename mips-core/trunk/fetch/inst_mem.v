`ifndef _inst_mem_v_
`define _inst_mem_v_
`endif

module inst_mem(addr, data);
  input wire [31:0] addr;
  output reg [31:0] data;

  reg [31:0] rf_data [127:0];

  always @(addr)
    data = rf_data[addr[6:0]];
    
  // lab 1 instruction memory data test
  /*
  initial begin
    rf_data[0] <= 32'hA00000AA;
    rf_data[1] <= 32'h10000011;
    rf_data[2] <= 32'h20000022;
    rf_data[3] <= 32'h30000033;
    rf_data[4] <= 32'h40000044;
    rf_data[5] <= 32'h50000055;
    rf_data[6] <= 32'h60000066;
    rf_data[7] <= 32'h70000077;
    rf_data[8] <= 32'h80000088;
    rf_data[9] <= 32'h90000099;
  end
  */
  
  // lab 2 instruction memory data test
  initial begin
    rf_data[0] <= 32'h002300aa;
    rf_data[1] <= 32'h10254321;
    rf_data[2] <= 32'h00200022;
    rf_data[3] <= 32'h8c123456;
    rf_data[4] <= 32'h8f123456;
    rf_data[5] <= 32'had654321;
    rf_data[6] <= 32'h13012345;
    rf_data[7] <= 32'hac654321;
    rf_data[8] <= 32'h12012345;

  
  end
endmodule