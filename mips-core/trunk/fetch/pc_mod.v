`ifndef _pc_mod_v_
`define _pc_mod_v_
`endif

module pc_mod(clk, npc, PC);

  input wire [31:0] npc;
  output reg [31:0] PC;
  input wire clk;
  
  initial
    PC<=0;
    
  always @(posedge clk)
    PC<=npc;


endmodule