`define _pipelinedproc_v_

`ifndef _alu_v_
`include "hw/ALU.v"
`endif

`ifndef _alucontrol_v_
`include "hw/ALUControl.v"
`endif

`ifndef _datamemory_v_
`include "hw/DataMemory.v"
`endif

`ifndef _registerfile_v_
`include "hw/RegisterFile.v"
`endif

`ifndef _controlunit_v_
`include "hw/ControlUnit.v"
`endif

`ifndef _instructionmemory_v_
`include "hw/InstructionMemory.v"
`endif

`ifndef _forwardingunit_v_
`include "hw/ForwardingUnit.v"
`endif

`ifndef _hazardunit_v_
`include "hw/HazardUnit.v"
`endif

`ifndef _if_id_v_
`include "hw/IF_ID.v"
`endif

`ifndef _id_ex_v_
`include "hw/ID_EX.v"
`endif

`ifndef _ex_mem_v_
`include "hw/EX_MEM.v"
`endif

`ifndef _mem_wb_v_
`include "hw/MEM_WB.v"
`endif

`ifndef _pc_v_
`include "hw/PC.v"
`endif

`ifndef _mux4to1_n_v_
`include "hw/mux4to1_n.v"
`endif

module PipelinedProc (CLK, Reset_L, startPC, dMemOut) ;

  input wire CLK;
  input wire Reset_L;                 // Asynchronous Reset, active low
  input wire [31:0] startPC;
  output wire [31:0] dMemOut;
 
  // Nets related to Control Unit
  wire UseShamt, UseImmed, Branch, Jump, SignExtend, Jr;
  
  wire [6:0] ID_ctrlEX,   EX_ctrlEX;                               // Execute control signals
  wire       ID_Jal,      EX_Jal;                                  //  ALU output mux to select PC+4 for JAL instruction
  wire [1:0] ID_RegDst,   EX_RegDst;                               //  Destination register mux select signal
  wire [3:0] ID_ALUOp,    EX_ALUOp;                                //  ALU control signal for non-R-type instructions
  wire [1:0] ID_ctrlMEM,  EX_ctrlMEM,  MEM_ctrlMEM;                // Memory control signals
  wire       ID_MemRead,  EX_MemRead,  MEM_MemRead;                //  For loads
  wire       ID_MemWrite,              MEM_MemWrite;               //  For stores
  wire [1:0] ID_ctrlWB,   EX_ctrlWB,   MEM_ctrlWB,   WB_ctrlWB;    // Writeback control signals
  wire       ID_RegWrite, EX_RegWrite, MEM_RegWrite, WB_RegWrite;  //  Write enable signal for register file
  wire       ID_RegSrc,                              WB_RegSrc;    //  Register write data select signal
  
  assign ID_ctrlEX = { ID_Jal, ID_RegDst, ID_ALUOp };
  assign EX_Jal    = EX_ctrlEX[6];
  assign EX_RegDst = EX_ctrlEX[5:4];
  assign EX_ALUOp  = EX_ctrlEX[3:0];

  assign ID_ctrlMEM   =  { ID_MemRead, ID_MemWrite };
  assign EX_MemRead   =  EX_ctrlMEM[1];
  assign MEM_MemRead  = MEM_ctrlMEM[1];
  assign MEM_MemWrite = MEM_ctrlMEM[0];
  
  assign ID_ctrlWB    =  { ID_RegWrite, ID_RegSrc };
  assign EX_RegWrite  =  EX_ctrlWB[1];
  assign MEM_RegWrite = MEM_ctrlWB[1];
  assign WB_RegWrite  =  WB_ctrlWB[1];
  assign WB_RegSrc    =  WB_ctrlWB[0]; 

  // Nets related to the Forwarding unit
  wire [1:0] ID_AluOpCtrlA,             EX_AluOpCtrlA;                    // Select signal for ALU input A
  wire [1:0] ID_AluOpCtrlB,             EX_AluOpCtrlB;                    // Select signal for ALU input B
  wire       ID_DataMemForwardCtrl_EX,  EX_DataMemForwardCtrl_EX;         // Controls data forwarding between EX and WB
  wire       ID_DataMemForwardCtrl_MEM, EX_DataMemForwardCtrl_MEM, MEM_DataMemForwardCtrl_MEM;  // Controls data forwarding between MEM and WB
  
  // Nets related to the Hazard Detection Unit
  wire       PC_write, IF_write, bubble;                            // Stall signals
  wire [1:0] addrSel;                                               // PC select signal

  // Nets related to ALU Control Unit
  wire [3:0] ALUCtrl;                                               // ALU control signal for R-type instructions
  
  // Instruction register and its derivatives
  wire [31:0] IF_IR, ID_IR;                                         // The instruction register
  wire [ 4:0] ID_Rs, ID_Rt, EX_Rt;                                  // Operand source registers
  wire [ 4:0] EX_Rd, EX_Rw, MEM_Rw, WB_Rw;                          // Operand destination register
  wire [ 5:0] ID_Opcode, ID_Funct, EX_Funct;                        // Opcode and ALU control information
  wire [15:0] ID_Imm;                                               // Immediate
  wire [31:0] ID_ExtImm, EX_ExtImm;                                 // (Sign/Zero) Extended Immediate
  wire [25:0] ID_IRaddr, EX_IRaddr;                                 // jmp target address. Also contains Rt, Rd, Shamt, and Funct information for non-jmp instructions
  wire [31:0] EX_Shamt;                                             // Shift amount for SLL, SRL, SRA
  
  assign ID_Opcode = ID_IR[31:26];  
  assign ID_Rs     = ID_IR[25:21];
  assign ID_Rt     = ID_IR[20:16];
  assign ID_Funct  = ID_IR[ 5: 0];
  assign ID_Imm    = ID_IR[15: 0];
  assign ID_IRaddr = ID_IR[25: 0];
  
  assign ID_ExtImm = (SignExtend) ? {{16{ID_Imm[15]}}, ID_Imm} : {16'b0, ID_Imm};  // Sign extend or zero extend the immediate value
  
  assign EX_Rt     = EX_IRaddr[20:16];
  assign EX_Rd     = EX_IRaddr[15:11];
  assign EX_Funct  = EX_IRaddr[5:0];

  mux4to1_n #(5) Rw_mux(                                   // Mux to select Rw
  	.i00(EX_Rt),
  	.i01(EX_Rd),
  	.i10(6'd31),
  	.i11(6'd0),
  	.sel(EX_RegDst),
  	.out(EX_Rw)
  );

  assign EX_Shamt  = {27'b0, EX_IRaddr[10:6]};
  
  // Nets related to the Program Counter
  wire [31:0] pc, npc;                                       // PC and next PC
  wire [31:0] IF_pc4, ID_pc4, EX_pc4;                        // PC+4
  wire [31:0] jumpTarget, branchTarget, jmpT;           
  
  assign IF_pc4       = pc + 4;
  assign jmpT   = { ID_pc4[31:28], ID_IRaddr, 2'b0 };  // JumpAddr = { PC+4[31:28], address, 2’b0 }
  assign jumpTarget = (Jr) ? (ID_RegA) : (jmpT);       // Mux to select jumpTarget for JMP or JR instructions
  assign branchTarget = EX_pc4 + { EX_ExtImm[29:0], 2'b0 };  // BranchAddr = { 14{immediate[15]}, immediate, 2’b0 }, NPC = PC + 4 + BranchAddr
  
  // mux to select next PC
  mux4to1_n #(32) pc_mux(
  	.i00(IF_pc4),
  	.i01(jumpTarget),
  	.i10(branchTarget),
  	.i11(32'b0),
  	.sel(addrSel),
  	.out(npc)
  );
  
  // Nets related to the Datapath
  wire [31:0] ID_RegA, EX_RegA;      // Data from RF[Rs]
  wire [31:0] ID_RegB, EX_RegB;      // Data from RF[Rt]
  
  wire [31:0] ALUOp1, ALUOp2;        // Inputs to ALU
  wire [31:0] EX_ALUOut_PreJal, EX_ALUOut, MEM_ALUOut, WB_ALUOut;
  wire        Zero;                  // High if ALU result = 0
 
  mux4to1_n #(32) alu_mux_1(         // ALU Input mux 1 
  	.i00(EX_RegA),
  	.i01(MEM_ALUOut),
  	.i10(WB_Out),
  	.i11(EX_Shamt),
  	.sel(EX_AluOpCtrlA),
  	.out(ALUOp1)
  );
  
  mux4to1_n #(32) alu_mux_2(         // ALU Input mux 2
    .i00(EX_RegB),
    .i01(MEM_ALUOut),
    .i10(WB_Out),
    .i11(EX_ExtImm),
    .sel(EX_AluOpCtrlB),
    .out(ALUOp2)
  );
  
  assign EX_ALUOut = (EX_Jal) ? (EX_pc4) : (EX_ALUOut_PreJal);   // ALU Output mux. Select PC+4 for JAL instruction, and ALUOut otherwise
  
  wire [31:0] EX_DMIn, MEM_DMIn, MEM_DataIn;                               // Value to be store to memory. 
  
  assign EX_DMIn  = (EX_DataMemForwardCtrl_EX)   ? (WB_Out) : (EX_RegB);   // Supports data forwarding from WB to EX
  assign MEM_DataIn = (MEM_DataMemForwardCtrl_MEM) ? (WB_Out) : (MEM_DMIn);  // Supports data forwarding from WB to MEM
  
  wire [31:0] MEM_dMemOut, WB_dMemOut;    // Data Memory Output
  wire [31:0] WB_Out;                     // Final result of instruction. Either from the ALU or from Data Memory
  
  assign WB_Out = (WB_RegSrc) ? (WB_dMemOut) : (WB_ALUOut);
  
  assign dMemOut = WB_dMemOut;     // Connect Data Memory Out to Output Pin
  
  
  // IF stage sub-modules (3)
  //  PC Unit, Instruction Memory, IF_ID Pipeline Registers
  
  PC PC(
  	.CLK(CLK),
  	.Reset_L(Reset_L),
  	.PC_write(PC_write),
  	.npc(npc),
  	.startPC(startPC),
  	.pc(pc)
  );
  
  InstructionMemory InstructionMemory(
  	.Data(IF_IR),
  	.Address(pc)
  );
  
  IF_ID IF_ID(
  	.CLK(CLK),
  	.IF_write(IF_write),
  	.IF_pc4(IF_pc4),
  	.IF_IR(IF_IR),
  	.ID_pc4(ID_pc4),
  	.ID_IR(ID_IR)
  );
  
  // ID stage sub-modules (5)
  //  Register File, Control Unit, Forwarding Unit, Hazard Detect Unit, ID_EX Pipeline Registers
  
  RegisterFile RegisterFile(
  	.BusA(ID_RegA),
  	.BusB(ID_RegB),
  	.BusW(WB_Out),
  	.RA(ID_Rs),
  	.RB(ID_Rt),
  	.RW(WB_Rw),
  	.RegWr(WB_RegWrite),
  	.Clk(CLK)
  );
  
  ControlUnit ControlUnit(
  	.Opcode(ID_Opcode),
  	.FuncCode(ID_Funct),
  	.bubble(bubble),
  	.ALUOp(ID_ALUOp),
  	.UseImmed(UseImmed),
  	.Branch(Branch),
  	.Jump(Jump),
  	.SignExtend(SignExtend),
  	.UseShamt(UseShamt),
  	.RegDst(ID_RegDst),
  	.RegSrc(ID_RegSrc),
  	.RegWrite(ID_RegWrite),
  	.MemRead(ID_MemRead),
  	.MemWrite(ID_MemWrite),
  	.Jal(ID_Jal),
  	.Jr(Jr)
  );
  
  ForwardingUnit ForwardingUnit(
  	.UseShamt(UseShamt),
  	.UseImmed(UseImmed),
  	.ID_Rs(ID_Rs),
  	.ID_Rt(ID_Rt),
  	.EX_Rw(EX_Rw),
  	.MEM_Rw(MEM_Rw),
  	.EX_RegWrite(EX_RegWrite),
  	.MEM_RegWrite(MEM_RegWrite),
  	.AluOpCtrlA(ID_AluOpCtrlA),
  	.AluOpCtrlB(ID_AluOpCtrlB),
  	.DataMemForwardCtrl_EX(ID_DataMemForwardCtrl_EX),
  	.DataMemForwardCtrl_MEM(ID_DataMemForwardCtrl_MEM)
  );
  
  HazardUnit HazardUnit(
  	.IF_write(IF_write),
  	.PC_write(PC_write),
  	.bubble(bubble),
  	.addrSel(addrSel),
  	.Jump(Jump),
  	.Branch(Branch),
  	.ALUZero(Zero),
  	.memReadEX(EX_MemRead),
  	.Clk(CLK),
  	.Rst(Reset_L),
  	.UseShamt(UseShamt),
  	.UseImmed(UseImmed),
  	.currRs(ID_Rs),
  	.currRt(ID_Rt),
  	.prevRt(EX_Rt),
  	.Jr(Jr), 
    .EX_RegWrite(EX_RegWrite), 
    .EX_Rw(EX_Rw),
    .MEM_RegWrite(MEM_RegWrite), 
    .MEM_Rw(MEM_Rw)  	
  );
  
  ID_EX ID_EX(
  	.CLK(CLK),
  	.Reset_L(Reset_L),
  	.ID_ctrlWB(ID_ctrlWB),
  	.ID_ctrlMEM(ID_ctrlMEM),
  	.ID_ctrlEX(ID_ctrlEX),
  	.ID_pc4(ID_pc4),
  	.ID_RegA(ID_RegA),
  	.ID_RegB(ID_RegB),
  	.ID_ExtImm(ID_ExtImm),
  	.ID_AluOpCtrlA(ID_AluOpCtrlA),
  	.ID_AluOpCtrlB(ID_AluOpCtrlB),
  	.ID_DataMemForwardCtrl_EX(ID_DataMemForwardCtrl_EX),
  	.ID_DataMemForwardCtrl_MEM(ID_DataMemForwardCtrl_MEM),
  	.ID_IRaddr(ID_IRaddr),
  	.EX_ctrlWB(EX_ctrlWB),
  	.EX_ctrlMEM(EX_ctrlMEM),
  	.EX_ctrlEX(EX_ctrlEX),
  	.EX_pc4(EX_pc4),
  	.EX_RegA(EX_RegA),
  	.EX_RegB(EX_RegB),
  	.EX_ExtImm(EX_ExtImm),
  	.EX_AluOpCtrlA(EX_AluOpCtrlA),
  	.EX_AluOpCtrlB(EX_AluOpCtrlB),
  	.EX_DataMemForwardCtrl_EX(EX_DataMemForwardCtrl_EX),
  	.EX_DataMemForwardCtrl_MEM(EX_DataMemForwardCtrl_MEM),
  	.EX_IRaddr(EX_IRaddr)
  );
  
  // EX stage sub-modules (3)
  //  ALU, ALU Control Unit, EX_MEM Pipeline Registers
  
  ALU ALU(
  	.BusA(ALUOp1),
  	.BusB(ALUOp2),
  	.ALUCtrl(ALUCtrl),
  	.BusW(EX_ALUOut_PreJal),
  	.Zero(Zero)
  );
  
  ALUControl ALUControl(
  	.ALUCtrl(ALUCtrl),
  	.ALUOp(EX_ALUOp),
  	.FuncCode(EX_Funct)
  );
  
  EX_MEM EX_MEM(
  	.CLK(CLK),
  	.Reset_L(Reset_L),
  	.EX_ctrlWB(EX_ctrlWB),
  	.EX_Rw(EX_Rw),
  	.EX_ctrlMEM(EX_ctrlMEM),
  	.EX_ALUOut(EX_ALUOut),
  	.EX_DMIn(EX_DMIn),
  	.EX_DataMemForwardCtrl_MEM(EX_DataMemForwardCtrl_MEM),
  	.MEM_ctrlWB(MEM_ctrlWB),
  	.MEM_Rw(MEM_Rw),
  	.MEM_ctrlMEM(MEM_ctrlMEM),
  	.MEM_ALUOut(MEM_ALUOut),
  	.MEM_DMIn(MEM_DMIn),
  	.MEM_DataMemForwardCtrl_MEM(MEM_DataMemForwardCtrl_MEM)
  );
  
  // MEM stage sub-modules (2)
  //  Data Memory, MEM_WB Pipeline Registers
  
  DataMemory DataMemory(
  	.ReadData(MEM_dMemOut),
  	.Address(MEM_ALUOut[5:0]),
  	.WriteData(MEM_DataIn),
  	.MemoryRead(MEM_MemRead),
  	.MemoryWrite(MEM_MemWrite),
  	.Clock(CLK)
  );
  
  MEM_WB MEM_WB(
  	.CLK(CLK),
  	.Reset_L(Reset_L),
  	.MEM_ctrlWB(MEM_ctrlWB),
  	.MEM_dMemOut(MEM_dMemOut),
  	.MEM_ALUOut(MEM_ALUOut),
  	.MEM_Rw(MEM_Rw),
  	.WB_ctrlWB(WB_ctrlWB),
  	.WB_dMemOut(WB_dMemOut),
  	.WB_ALUOut(WB_ALUOut),
  	.WB_Rw(WB_Rw)
  );
  
  // WB stage sub-modules (0)

endmodule