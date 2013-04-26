`ifndef _id_ex_v_
`define _id_ex_v_
`endif

module id_ex(clk,
      ID_ctlwb, ID_ctlm, ID_ctlex, ID_npc, ID_rd1, ID_rd2, ID_imm, ID_rt, ID_rd,
      EX_ctlwb, EX_ctlm, EX_ctlex, EX_npc, EX_rd1, EX_rd2, EX_imm, EX_rt, EX_rd
      );

  input wire clk;
  
  input wire [1:0] ID_ctlwb;
  input wire [2:0] ID_ctlm;
  input wire [3:0] ID_ctlex;
  input wire [31:0] ID_npc, ID_rd1, ID_rd2, ID_imm;
  input wire [4:0] ID_rt, ID_rd;

  output reg [1:0] EX_ctlwb;
  output reg [2:0] EX_ctlm;
  output reg [3:0] EX_ctlex;
  output reg [31:0] EX_npc, EX_rd1, EX_rd2, EX_imm;
  output reg [4:0] EX_rt, EX_rd;
  
  initial begin
    EX_ctlwb <= 0;
    EX_ctlm <= 0;
    EX_ctlex <= 0;
  end
  
  always @(posedge clk) begin
    EX_ctlwb <= ID_ctlwb;
    EX_ctlm  <= ID_ctlm;
    EX_ctlex <= ID_ctlex;
    EX_npc   <= ID_npc;
    EX_rd1   <= ID_rd1;
    EX_rd2   <= ID_rd2;
    EX_imm   <= ID_imm;
    EX_rt    <= ID_rt;
    EX_rd    <= ID_rd;
  end

endmodule