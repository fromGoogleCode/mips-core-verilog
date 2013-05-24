`ifndef _controlunit_v_
`define _controlunit_v_
`endif 

`ifndef _alucontrol_v_
`include "hw/ALUControl.v"
`endif

`define RTYPEOPCODE 6'b000000
`define LWOPCODE    6'b100011
`define SWOPCODE    6'b101011
`define BEQOPCODE   6'b000100
`define JOPCODE     6'b000010
`define ORIOPCODE   6'b001101
`define ADDIOPCODE  6'b001000
`define ADDIUOPCODE 6'b001001
`define ANDIOPCODE  6'b001100
`define LUIOPCODE   6'b001111
`define SLTIOPCODE  6'b001010
`define SLTIUOPCODE 6'b001011
`define XORIOPCODE  6'b001110

module ControlUnit(RegDst, UseShamt,UseImmed, MemToReg, RegWrite, 
             MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode, FuncCode, bubble);

  input wire [5:0] Opcode;
  input wire [5:0] FuncCode;
  input wire bubble;
  output wire [3:0] ALUOp;
  output reg UseImmed, Branch, Jump, SignExtend;
  output wire UseShamt, RegDst, MemToReg, RegWrite, MemRead, MemWrite;
  
  reg ShiftInst;
  reg RegDst_nb, MemToReg_nb, RegWrite_nb, MemRead_nb, MemWrite_nb;  // Signals before bubble input is considered (No Bubble)
  reg [3:0] ALUOp_nb;

  // Set all pipelined control signals to zero when bubble is high
  assign RegDst   = ~bubble & RegDst_nb ;
  assign MemToReg = ~bubble & MemToReg_nb ;
  assign RegWrite = ~bubble & RegWrite_nb ;
  assign MemRead  = ~bubble & MemRead_nb ;
  assign MemWrite = ~bubble & MemWrite_nb ;
  assign ALUOp    = ~bubble & ALUOp_nb;
  
  always @(*) begin
    case(Opcode)
      `RTYPEOPCODE: begin
                      ALUOp_nb = 4'b1111;  // ALUOp will be decoded from FuncCode by ALUControl
                      RegDst_nb = 1;       // R-Type instructions write to register RD
                      RegWrite_nb = 1;
                      UseImmed=0; MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `LWOPCODE:    begin
                      ALUOp_nb = `ADD;     // R[rt] = M[R[rs]+SignExtImm]  
                      SignExtend = 1;   // Sign extend Imm
                      UseImmed = 1;      // Then send it to the ALU input 2
                      MemRead_nb = 1;      // Read from memory
                      MemToReg_nb = 1;     // Send data from memory to register file
                      RegWrite_nb = 1;     // Write data to register file
                      RegDst_nb=0;  MemWrite_nb=0; Branch=0; Jump=0; 
                    end
      `SWOPCODE:    begin
                      ALUOp_nb = `ADD;     // M[R[rs]+SignExtImm] = R[rt]
                      SignExtend = 1;   // Sign extend Imm
                      UseImmed = 1;      // Send Imm to ALU input 2
                      MemWrite_nb = 1;     // Write data to memory     
                      RegDst_nb=0;  MemToReg_nb=0; RegWrite_nb=0; MemRead_nb=0;  Branch=0; Jump=0; 
                    end
      `BEQOPCODE:   begin
                      ALUOp_nb = `SUB;     // if(R[rs]==R[rt]), then PC=PC+4+BranchAddr
                      Branch = 1;       
                      SignExtend = 1;   // Sign extend because:  BranchAddr = { 14{immediate[15]}, immediate, 2’b0 }
                      RegDst_nb=0;  UseImmed=0; MemToReg_nb=0; RegWrite_nb=0; MemRead_nb=0; MemWrite_nb=0; Jump=0; 
                    end
      `JOPCODE:     begin
                      ALUOp_nb = 0;        // PC=JumpAddr,     JumpAddr = { PC+4[31:28], address, 2’b0 }
                      Jump = 1;
                      RegDst_nb=0;  UseImmed=0; MemToReg_nb=0; RegWrite_nb=0; MemRead_nb=0; MemWrite_nb=0; Branch=0;  SignExtend=0;
                    end
      `ORIOPCODE:   begin
                      ALUOp_nb = `OR;      // R[rt] = R[rs] | ZeroExtImm
                      UseImmed = 1;
                      RegWrite_nb = 1;
                      RegDst_nb=0;   MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `ADDIOPCODE:  begin               // R[rt] = R[rs] + SignExtImm
                      ALUOp_nb = `ADD;
                      UseImmed = 1; 
                      SignExtend = 1;
                      RegWrite_nb = 1;
                      RegDst_nb=0;  MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; 
                    end
      `ADDIUOPCODE: begin               // R[rt] = R[rs] + SignExtImm
                      ALUOp_nb = `ADDU;
                      UseImmed = 1;
                      SignExtend = 1;
                      RegWrite_nb = 1;
                      RegDst_nb=0;   MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; 
                    end
      `ANDIOPCODE:  begin               // R[rt] = R[rs] & ZeroExtImm
                      ALUOp_nb = `AND;
                      UseImmed = 1;
                      RegWrite_nb = 1; 
                      RegDst_nb=0;  MemToReg_nb=0; MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `LUIOPCODE:   begin               // R[rt] = {imm, 16’b0}
                      ALUOp_nb = `LUI;
                      UseImmed = 1;
                      RegWrite_nb = 1;
                      RegDst_nb=0;   MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `SLTIOPCODE:  begin               // R[rt] = (R[rs] < SignExtImm)? 1 : 0
                      ALUOp_nb = `SLT;
                      UseImmed = 1;
                      SignExtend = 1;
                      RegWrite_nb = 1;
                      RegDst_nb=0;   MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; 
                    end
      `SLTIUOPCODE: begin               // R[rt] = (R[rs] < SignExtImm)? 1 : 0
                      ALUOp_nb = `SLTU;
                      UseImmed = 1;
                      SignExtend = 1;
                      RegWrite_nb = 1;
                      RegDst_nb=0;  MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; 
                    end
      `XORIOPCODE:  begin               // // R[rt] = R[rs] ^ ZeroExtImm 
                      ALUOp_nb = `XOR;
                      UseImmed = 1;
                      RegWrite_nb = 1;
                      RegDst_nb=0; MemToReg_nb=0;  MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; SignExtend=0;
                    end
       default:     begin
                      ALUOp_nb = 0;
                      RegDst_nb=0;  UseImmed=0; MemToReg_nb=0; RegWrite_nb=0; MemRead_nb=0; MemWrite_nb=0; Branch=0; Jump=0; SignExtend=0;
                    end
    endcase
  end            
  
  
  always @ (*) begin  // Determine if this is a Shift instruction
    case(FuncCode) 
      `SLLFunc:  ShiftInst = 1;
      `SRLFunc:  ShiftInst = 1;
      `SRAFunc:  ShiftInst = 1;
      `ADDFunc:  ShiftInst = 0;
      `ADDUFunc: ShiftInst = 0;
      `SUBFunc:  ShiftInst = 0;
      `SUBUFunc: ShiftInst = 0;
      `ANDFunc:  ShiftInst = 0;
      `ORFunc:   ShiftInst = 0;
      `XORFunc:  ShiftInst = 0;
      `NORFunc:  ShiftInst = 0;
      `SLTFunc:  ShiftInst = 0;
      `SLTUFunc: ShiftInst = 0;
      default:   ShiftInst = 0;      
    endcase  
  end
            
  // Set UseShamt high only if both the instruction is R-type and the operation is a shift
  assign UseShamt = (Opcode == `RTYPEOPCODE) & ShiftInst;
            
endmodule