`define _forwardingunit_v_


module ForwardingUnit ( UseShamt , UseImmed , ID_Rs , ID_Rt , EX_Rw, MEM_Rw,
                        EX_RegWrite , MEM_RegWrite , AluOpCtrlA , AluOpCtrlB , DataMemForwardCtrl_EX ,
                        DataMemForwardCtrl_MEM ) ;
  input wire UseShamt, UseImmed;
  input wire [4:0] ID_Rs, ID_Rt, EX_Rw, MEM_Rw;
  input wire EX_RegWrite, MEM_RegWrite;
  output wire [1:0] AluOpCtrlA, AluOpCtrlB;
  output wire DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM;
  
  // Detect all potential RAW hazards
  wire A_EX_0  = (ID_Rs ==  EX_Rw);  // RAW: ALU port A from Instruction -1  
  wire A_MEM_0 = (ID_Rs == MEM_Rw);  // RAW: ALU port A from Instruction -2
  wire B_EX_0  = (ID_Rt ==  EX_Rw);  // RAW: ALU port B from Instruction -1
  wire B_MEM_0 = (ID_Rt == MEM_Rw);  // RAW: ALU port B from Instruction -2
  
  // Determine if the RAW hazards are valid. That is, are the previous instructions actually writing to the destination register?
  wire A_EX  = A_EX_0  &  EX_RegWrite;
  wire A_MEM = A_MEM_0 & MEM_RegWrite;
  wire B_EX  = B_EX_0  &  EX_RegWrite;
  wire B_MEM = B_MEM_0 & MEM_RegWrite;
   
  // writes to R0 must be ignored
  wire AnotR0 = | ID_Rs;
  wire BnotR0 = | ID_Rt;
    
  /*
    ALU Muxes:   __MUX_A__             __MUX_B__
              Select   Value         Select  Value
                  00   EX_RegA           00  EX_RegB
                  01   MEM_ALUOut        01  MEM_ALUOut
                  10   WB_Out            10  WB_Out
                  11   EX_Shamt          11  EX_ExtImm                 
  */
  
  // Forwarding logic for
  // The ALU MUX control signals
  //assign AluOpCtrlA[1]  = ( AnotR0 & UseShamt ) | ( AnotR0 & ~A_EX & A_MEM );    // Removed the check if Rs=R0 for shift instructions, since Rs is not used
  //assign AluOpCtrlA[0]  = ( AnotR0 & UseShamt ) | ( AnotR0 &  A_EX );
  assign AluOpCtrlA[1]  = (  UseShamt ) | ( AnotR0 & ~A_EX & A_MEM );
  assign AluOpCtrlA[0]  = (  UseShamt ) | ( AnotR0 &  A_EX );
  
  assign AluOpCtrlB[1]  = ( BnotR0 & UseImmed ) | ( BnotR0 & ~B_EX & B_MEM );
  assign AluOpCtrlB[0]  = ( BnotR0 & UseImmed ) | ( BnotR0 &  B_EX );

  // Forwarding logic for the Data Memory DataIn Muxes ( store instructions ) ( stores write value Rt to memory )
  // Highest priority is given to the most recent instruction producing the value. This is done by placing the multiplexers in series
  // If the dependent value comes from the previous instruction, Instruction -1, then forward data from WB to MEM
  assign DataMemForwardCtrl_MEM = B_EX & BnotR0;
    
  // If the dependent value comes from two instructions before, Instruction -2, then forward data from WB to EX
  assign DataMemForwardCtrl_EX = B_MEM & BnotR0;
  

  
endmodule