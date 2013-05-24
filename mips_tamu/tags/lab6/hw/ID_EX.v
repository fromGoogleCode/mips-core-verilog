`define _id_ex_v_


module ID_EX(CLK, Reset_L,  
             ID_ctrlWB, ID_ctrlMEM, ID_ctrlEX, ID_pc4, ID_RegA, ID_RegB, ID_ExtImm, ID_AluOpCtrlA, ID_AluOpCtrlB, ID_DataMemForwardCtrl_EX, ID_DataMemForwardCtrl_MEM, ID_IRaddr, 
             EX_ctrlWB, EX_ctrlMEM, EX_ctrlEX, EX_pc4, EX_RegA, EX_RegB, EX_ExtImm, EX_AluOpCtrlA, EX_AluOpCtrlB, EX_DataMemForwardCtrl_EX, EX_DataMemForwardCtrl_MEM, EX_IRaddr
             );

  input wire        CLK, Reset_L;  
  input wire [ 4:0] ID_ctrlEX;
  input wire [ 1:0] ID_ctrlMEM, ID_ctrlWB, ID_AluOpCtrlA, ID_AluOpCtrlB;  
  input wire [31:0] ID_pc4, ID_RegA, ID_RegB, ID_ExtImm;
  input wire        ID_DataMemForwardCtrl_EX, ID_DataMemForwardCtrl_MEM;
  input wire [25:0] ID_IRaddr;
             
  output reg [ 4:0] EX_ctrlEX;
  output reg [ 1:0] EX_ctrlMEM, EX_ctrlWB, EX_AluOpCtrlA, EX_AluOpCtrlB;  
  output reg [31:0] EX_pc4, EX_RegA, EX_RegB, EX_ExtImm;           
  output reg        EX_DataMemForwardCtrl_EX, EX_DataMemForwardCtrl_MEM;
  output reg [25:0] EX_IRaddr;

  // Resetable control signals first
  always @ (negedge CLK) begin
    if (Reset_L) begin
        EX_ctrlWB  <= ID_ctrlWB;
        EX_ctrlMEM <= ID_ctrlMEM;
        EX_ctrlEX  <= ID_ctrlEX;
      end
    else begin
        EX_ctrlWB  <= 5'b0;
        EX_ctrlMEM <= 2'b0;
        EX_ctrlEX  <= 2'b0;    
      end
  end

  always @ (negedge CLK) begin
    EX_pc4                    <= ID_pc4;
    EX_RegA                   <= ID_RegA;
    EX_RegB                   <= ID_RegB;
    EX_ExtImm                 <= ID_ExtImm;
    EX_AluOpCtrlA             <= ID_AluOpCtrlA;
    EX_AluOpCtrlB             <= ID_AluOpCtrlB;
    EX_DataMemForwardCtrl_EX  <= ID_DataMemForwardCtrl_EX;
    EX_DataMemForwardCtrl_MEM <= ID_DataMemForwardCtrl_MEM;
    EX_IRaddr                 <= ID_IRaddr;
  end

endmodule