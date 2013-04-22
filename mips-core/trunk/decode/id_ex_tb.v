`include "decode/id_ex.v"

module id_ex_tb();

  reg clk = 0;

  reg [1:0] ID_ctlwb=0;
  reg [2:0] ID_ctlm=0;
  reg [3:0] ID_ctlex=0;
  reg [31:0] ID_npc=0, ID_rd1=0, ID_rd2=0, ID_imm=0;
  reg [4:0] ID_rt=0, ID_rd=0;

  wire [1:0] EX_ctlwb;
  wire [2:0] EX_ctlm;
  wire [3:0] EX_ctlex;
  wire [31:0] EX_npc, EX_rd1, EX_rd2, EX_imm;
  wire [4:0] EX_rt, EX_rd;
  
  id_ex id_ex(
  	.clk(clk),
  	.ID_ctlwb(ID_ctlwb),
  	.ID_ctlm(ID_ctlm),
  	.ID_ctlex(ID_ctlex),
  	.ID_npc(ID_npc),
  	.ID_rd1(ID_rd1),
  	.ID_rd2(ID_rd2),
  	.ID_imm(ID_imm),
  	.ID_rt(ID_rt),
  	.ID_rd(ID_rd),
  	.EX_ctlwb(EX_ctlwb),
  	.EX_ctlm(EX_ctlm),
  	.EX_ctlex(EX_ctlex),
  	.EX_npc(EX_npc),
  	.EX_rd1(EX_rd1),
  	.EX_rd2(EX_rd2),
  	.EX_imm(EX_imm),
  	.EX_rt(EX_rt),
  	.EX_rd(EX_rd)
  );
  
  always
    #1 clk = !clk;

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, id_ex_tb);
    
    #5
    ID_ctlwb <= 2'h1;
    ID_ctlm  <= 3'h2;
    ID_ctlex <= 4'h3;
    ID_npc   <= 32'h4;
    ID_rd1   <= 32'h5;
    ID_rd2   <= 32'h6;
    ID_imm   <= 32'h7;
    ID_rt    <= 5'h8;
    ID_rd    <= 5'h9;
    
    #10 $finish;
  end

endmodule