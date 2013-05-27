`define _ex_mem_v_


module EX_MEM(CLK, Reset_L,
               EX_ctrlWB,  EX_ctrlMEM,  EX_ALUOut,  EX_DMIn,  EX_Rw,  EX_DataMemForwardCtrl_MEM,
              MEM_ctrlWB, MEM_ctrlMEM, MEM_ALUOut, MEM_DMIn, MEM_Rw, MEM_DataMemForwardCtrl_MEM
              );

  input wire        CLK, Reset_L;
  input wire [ 4:0] EX_Rw;
  input wire [ 1:0] EX_ctrlMEM, EX_ctrlWB;
  input wire [31:0] EX_ALUOut,  EX_DMIn;
  input wire        EX_DataMemForwardCtrl_MEM;
  
  output reg [ 4:0] MEM_Rw;
  output reg [ 1:0] MEM_ctrlMEM, MEM_ctrlWB;
  output reg [31:0] MEM_ALUOut, MEM_DMIn;
  output reg        MEM_DataMemForwardCtrl_MEM;
  
  // Resetable control signals first
  always @ (negedge CLK) begin
    if (Reset_L) begin
      MEM_ctrlWB  <= EX_ctrlWB;
      MEM_ctrlMEM <= EX_ctrlMEM;
      end
    else begin
      MEM_ctrlWB  <= 4'b0;
      MEM_ctrlMEM <= 2'b0;    
      end
  end

  always @ (negedge CLK) begin
    MEM_ALUOut                 <= EX_ALUOut;
    MEM_DMIn                   <= EX_DMIn;
    MEM_Rw                     <= EX_Rw;
    MEM_DataMemForwardCtrl_MEM <= EX_DataMemForwardCtrl_MEM;   
  end

endmodule