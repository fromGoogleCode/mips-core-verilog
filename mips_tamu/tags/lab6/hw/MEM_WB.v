`define _mem_wb_v_



module MEM_WB(CLK, Reset_L,
              MEM_ctrlWB, MEM_dMemOut, MEM_ALUOut, MEM_Rw,
              WB_ctrlWB, WB_dMemOut, WB_ALUOut, WB_Rw
              );

  input wire CLK, Reset_L;
  input wire [ 1:0] MEM_ctrlWB;
  input wire [31:0] MEM_dMemOut, MEM_ALUOut;
  input wire [ 4:0] MEM_Rw;
  
  output reg [ 1:0] WB_ctrlWB;
  output reg [31:0] WB_dMemOut, WB_ALUOut;
  output reg [ 4:0] WB_Rw;

  // Resetable control signals first
  always @ (negedge CLK) begin
    if (Reset_L)
      WB_ctrlWB <= MEM_ctrlWB;
    else
      WB_ctrlWB <= 2'b0;
  end

  always @ (negedge CLK) begin
    WB_dMemOut <= MEM_dMemOut;
    WB_ALUOut  <= MEM_ALUOut;
    WB_Rw      <= MEM_Rw;
  end


endmodule