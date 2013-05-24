`define _pc_v_

module PC(CLK, Reset_L, startPC, PC_write, pc, npc);

  input wire CLK, Reset_L, PC_write;   // Sensitive to negedge CLK. Reset_L is active low and synchronous. 
  input wire [31:0] npc, startPC;
  output reg [31:0] pc;
  
  always @(negedge CLK) begin
    if (~Reset_L)        // Reset, active low
      pc <= startPC;
    else if (PC_write)   // Write, active high
      pc <= npc;
    else
      pc <= pc;  
  end

endmodule