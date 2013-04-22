`include "decode/reg_file.v"

module reg_file_tb();
  reg clk = 0;
  reg WB_wen;
  reg [4:0] rs=0, rt=1, WB_rd=0;
  reg [31:0] WB_wdata=0;
  wire [31:0] ID_rd1, ID_rd2;
  reg [4:0] counter=0;

  reg_file reg_file(
    .clk(clk),
    .WB_wen(WB_wen),
    .rs(rs),
    .rt(rt),
    .WB_rd(WB_rd),
    .WB_wdata(WB_wdata),
    .ID_rd1(ID_rd1),
    .ID_rd2(ID_rd2)
  );
  
  always
    #1 clk = !clk;
    
  always
    #2 counter = counter + 1;
    
  always @(counter)
    WB_rd = counter;
    
  always @(counter)
    rs = counter;
    
  always @(counter)
    rt = counter +1;
   
  always @(counter)
    WB_wdata = {11'd0, counter, 16'd0};
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, reg_file_tb);
    
    WB_wen = 1;
    #64 WB_wen = 0;
  
    #76 $finish;
  end

endmodule