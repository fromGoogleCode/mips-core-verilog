`ifndef _singlecyclecontrol_v_
`define _singlecyclecontrol_v_
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

module SingleCycleControl(RegDst, ALUSrc1,ALUSrc2, MemToReg, RegWrite, 
             MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode, FuncCode);

  input wire [5:0] Opcode;
  input wire [5:0] FuncCode;
  output reg [3:0] ALUOp;
  output reg RegDst, ALUSrc2, MemToReg, RegWrite, 
             MemRead, MemWrite, Branch, Jump, SignExtend;
  output wire ALUSrc1;
  
  reg ShiftInst;
  
  always @(*) begin
    case(Opcode)
      `RTYPEOPCODE: begin
                      ALUOp = 4'b1111;  // ALUOp will be decoded from FuncCode by ALUControl
                      RegDst = 1;       // R-Type instructions write to register RD
                      RegWrite = 1;
                      ALUSrc2=0; MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `LWOPCODE:    begin
                      ALUOp = `ADD;     // R[rt] = M[R[rs]+SignExtImm]  
                      SignExtend = 1;   // Sign extend Imm
                      ALUSrc2 = 1;      // Then send it to the ALU input 2
                      MemRead = 1;      // Read from memory
                      MemToReg = 1;     // Send data from memory to register file
                      RegWrite = 1;     // Write data to register file
                      RegDst=0;  MemWrite=0; Branch=0; Jump=0; 
                    end
      `SWOPCODE:    begin
                      ALUOp = `ADD;     // M[R[rs]+SignExtImm] = R[rt]
                      SignExtend = 1;   // Sign extend Imm
                      ALUSrc2 = 1;      // Send Imm to ALU input 2
                      MemWrite = 1;     // Write data to memory     
                      RegDst=0;  MemToReg=0; RegWrite=0; MemRead=0;  Branch=0; Jump=0; 
                    end
      `BEQOPCODE:   begin
                      ALUOp = `SUB;     // if(R[rs]==R[rt]), then PC=PC+4+BranchAddr
                      Branch = 1;       
                      SignExtend = 1;   // Sign extend because:  BranchAddr = { 14{immediate[15]}, immediate, 2’b0 }
                      RegDst=0;  ALUSrc2=0; MemToReg=0; RegWrite=0; MemRead=0; MemWrite=0; Jump=0; 
                    end
      `JOPCODE:     begin
                      ALUOp = 0;        // PC=JumpAddr,     JumpAddr = { PC+4[31:28], address, 2’b0 }
                      Jump = 1;
                      RegDst=0;  ALUSrc2=0; MemToReg=0; RegWrite=0; MemRead=0; MemWrite=0; Branch=0;  SignExtend=0;
                    end
      `ORIOPCODE:   begin
                      ALUOp = `OR;      // R[rt] = R[rs] | ZeroExtImm
                      ALUSrc2 = 1;
                      RegWrite = 1;
                      RegDst=0;   MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `ADDIOPCODE:  begin               // R[rt] = R[rs] + SignExtImm
                      ALUOp = `ADD;
                      ALUSrc2 = 1; 
                      SignExtend = 1;
                      RegWrite = 1;
                      RegDst=0;  MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; 
                    end
      `ADDIUOPCODE: begin               // R[rt] = R[rs] + SignExtImm
                      ALUOp = `ADDU;
                      ALUSrc2 = 1;
                      SignExtend = 1;
                      RegWrite = 1;
                      RegDst=0;   MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; 
                    end
      `ANDIOPCODE:  begin               // R[rt] = R[rs] & ZeroExtImm
                      ALUOp = `AND;
                      ALUSrc2 = 1;
                      RegWrite = 1; 
                      RegDst=0;  MemToReg=0; MemRead=0; MemWrite=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `LUIOPCODE:   begin               // R[rt] = {imm, 16’b0}
                      ALUOp = `LUI;
                      ALUSrc2 = 1;
                      RegWrite = 1;
                      RegDst=0;   MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; SignExtend=0;
                    end
      `SLTIOPCODE:  begin               // R[rt] = (R[rs] < SignExtImm)? 1 : 0
                      ALUOp = `SLT;
                      ALUSrc2 = 1;
                      SignExtend = 1;
                      RegWrite = 1;
                      RegDst=0;   MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; 
                    end
      `SLTIUOPCODE: begin               // R[rt] = (R[rs] < SignExtImm)? 1 : 0
                      ALUOp = `SLTU;
                      ALUSrc2 = 1;
                      SignExtend = 1;
                      RegWrite = 1;
                      RegDst=0;  MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; 
                    end
      `XORIOPCODE:  begin               // // R[rt] = R[rs] ^ ZeroExtImm 
                      ALUOp = `XOR;
                      ALUSrc2 = 1;
                      RegWrite = 1;
                      RegDst=0; MemToReg=0;  MemRead=0; MemWrite=0; Branch=0; Jump=0; SignExtend=0;
                    end
       default:     begin
                      ALUOp = 0;
                      RegDst=0;  ALUSrc2=0; MemToReg=0; RegWrite=0; MemRead=0; MemWrite=0; Branch=0; Jump=0; SignExtend=0;
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
            
  // Set ALUSrc1 high only if both the instruction is R-type and the operation is a shift
  assign ALUSrc1 = (Opcode == `RTYPEOPCODE) & ShiftInst;
            
endmodule