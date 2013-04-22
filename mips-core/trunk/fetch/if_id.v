`ifndef _if_id_v_
`define _if_id_v_
`endif

module if_id(clk, IF_ir, IF_npc, ID_ir, ID_npc);
  input wire [31:0] IF_ir, IF_npc;
  output reg [31:0] ID_ir, ID_npc;
  input clk;

  always @(posedge clk) begin
    ID_ir <= IF_ir;
    ID_npc <= IF_npc;
  
  end
  
  //initialilze data for test
  initial begin
    ID_ir <= 0;
    ID_npc <= 0;
  end
  
endmodule