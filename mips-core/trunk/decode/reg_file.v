`ifndef _reg_file_v_
`define _reg_file_v_
`endif

module reg_file(clk, rs, rt, WB_rd, WB_wdata, WB_wen, ID_rd1, ID_rd2);

  input wire clk, WB_wen;
  input wire [4:0] rs, rt, WB_rd;
  input wire [31:0] WB_wdata;
  output wire [31:0] ID_rd1, ID_rd2;
  
  reg [31:0] reg_data [31:0];
  
  integer i;
  
  assign ID_rd1 = reg_data[rs];
  assign ID_rd2 = reg_data[rt];
  
  initial begin
          for (i = 0; i < 32; i = i + 1)
                reg_data[i] <= i;
  end
  
  always @(posedge clk) begin
    if (WB_wen) reg_data[WB_rd] <= WB_wdata;
  end
  
endmodule