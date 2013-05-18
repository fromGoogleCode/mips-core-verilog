`ifndef _singlecycleproc_v_
`define _singlecycleproc_v_
`endif

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

`ifndef _singlecyclecontrol_v_
`include "hw/SingleCycleControl.v"
`endif

`ifndef _instructionmemory_v_
`include "hw/InstructionMemory.v"
`endif

module SingleCycleProc(CLK, Reset_L, startPC, dMemOut);

  input wire CLK;
  input wire Reset_L;                 // Asynchronous Reset, active low
  input wire [31:0] startPC;
  output wire [31:0] dMemOut;
 
  // Nets related to IR
  wire [31:0] IR;                     // Instruction register
  wire [ 5:0] Opcode  =  IR[31:26];   // Opcode
  wire [ 4:0] Rs      =  IR[25:21];
  wire [ 4:0] Rt      =  IR[20:16];
  wire [ 4:0] Rd      =  IR[15:11];
  wire [ 4:0] Shamt   =  IR[10: 6];   // Shift amount
  wire [ 5:0] Funct   =  IR[ 5: 0];   // ALU function for R-Type instructions
  wire [15:0] Imm     =  IR[15: 0];   // Immediate for I-type instructions
  wire [25:0] jumpT_0 =  IR[25: 0];   // Address for J-type instructions
  
  // Control Signals
  wire [3:0] ALUOp;
  wire RegDst, ALUSrc1, ALUSrc2, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, SignExtend;

  // Nets related to ALU
  wire [31:0] ALUOut;                 
  wire Zero;                          // (ALUOut == 0)
  wire [31:0] ALUOp1;                 // ALU input 1;
  wire [31:0] ALUOp1_0;               // Mux input 0, from register file BusA
  wire [31:0] ALUOp1_1 = {27'b0, Shamt};  // Mux input 1. Zero extended Shift Amount
  wire [31:0] ALUOp2;                 // ALU Input 2
  wire [31:0] ALUOp2_0;               // Mux input 0; from register file BusB
  wire [31:0] ExtImm;                 // Mux Input 1; Sign/Zero Extended Immediate value
  wire [ 5:0] FuncCode = ExtImm[5:0]; // Function field for R-type ALU instructions
  wire [ 3:0] ALUCtrl;                // Control signals sent to ALU

  // Nets related to PC
  reg  [31:0] pc;                     // The current PC
  wire [31:0] npc;                    // The next PC: either (PC+4), (branchTarget), or (jumpTarget)
  wire [31:0] pc_0;                   // PC+4
  wire [31:0] branchTarget;           // Target of branch instruction
  wire [31:0] jumpTarget;             // Target of jmp instruction
  wire [31:0] branchTarget_0;         // intermediate value; ExtImm << 2
  wire [31:0] pc_1;                   // Intermediate value; Either = (PC+4) or (branchTarget)
  wire Sel_Branch;                    // Control signal for pc_1 mux
  wire [3:0] jumpT_1;                 // MSBs of jumpTarget

  // Nets related to Register File Write
  wire [31:0] RegWriteData = (MemToReg) ? (dMemOut) : (ALUOut);  // Write data;  Write dMemOut to RF for loads, and ALUOut to RF for ALU instructions
  wire [ 4:0] Rw = (RegDst) ? (Rd) : (Rt);                       // Write destination

  // ALU input muxes and related nets
  assign ALUOp1 = (ALUSrc1) ? (ALUOp1_1) : (ALUOp1_0);                 // ALU input 1 mux
  assign ALUOp2 = (ALUSrc2) ? (ExtImm) : (ALUOp2_0);                   // ALU input 2 mux
  assign ExtImm = (SignExtend) ? {{16{Imm[15]}},Imm} : {16'b0, Imm};   // Sign extend or Zero extend the immediate value based on value of control signal SignExtend

  // Nets related to PC
  assign pc_0 = pc + 4;                           // pc + 4
  assign branchTarget_0 = {ExtImm[29:0], 2'b0};   // BranchAddr = ExtImm << 2
  assign branchTarget = pc_0 + branchTarget_0;    // branch target = PC+4+BranchAddr
  assign Sel_Branch = Branch & Zero;              // Branch only if this is a BEQ instruction and the ALU output is zero
  assign pc_1 = (Sel_Branch) ? (branchTarget) : (pc_0);   // Intermediate value; Either = (PC+4) or (branchTarget)
  assign jumpT_1 = pc_0[31:28];                   // MSBs of jumpTarget
  assign jumpTarget = {jumpT_1, jumpT_0, 2'b0};   // Target of jmp instruction
  assign npc = (Jump) ? (jumpTarget) : (pc_1);   
  
  // The actual PC register
  always @(negedge CLK or negedge Reset_L) begin
    if ( Reset_L == 0 )
      pc <= startPC;
    else
      pc <= npc;  
  end
  
  // Instantiate all sub-modules
  
  InstructionMemory InstructionMemory(
  	.Data(IR),
  	.Address(pc)
  ); 
  
  SingleCycleControl SingleCycleControl(
  	.Opcode(Opcode),
  	.FuncCode(Funct),
  	.ALUOp(ALUOp),
  	.RegDst(RegDst),
  	.ALUSrc2(ALUSrc2),
  	.MemToReg(MemToReg),
  	.RegWrite(RegWrite),
  	.MemRead(MemRead),
  	.MemWrite(MemWrite),
  	.Branch(Branch),
  	.Jump(Jump),
  	.SignExtend(SignExtend),
  	.ALUSrc1(ALUSrc1)
  );
  
  RegisterFile RegisterFile(
  	.BusA(ALUOp1_0),
  	.BusB(ALUOp2_0),
  	.BusW(RegWriteData),
  	.RA(Rs),
  	.RB(Rt),
  	.RW(Rw),
  	.RegWr(RegWrite),
  	.Clk(CLK)
  );
  
  ALUControl ALUControl(
  	.ALUCtrl(ALUCtrl),
  	.ALUop(ALUOp),
  	.FuncCode(FuncCode)
  );
  
  ALU ALU(
  	.BusA(ALUOp1),
  	.BusB(ALUOp2),
  	.ALUCtrl(ALUCtrl),
  	.BusW(ALUOut),
  	.Zero(Zero)
  );
  
  DataMemory DataMemory(
  	.ReadData(dMemOut),
  	.Address(ALUOut[5:0]),              // Data Memory size is limited, so only 6 bits of address needed
  	.WriteData(ALUOp2_0),
  	.MemoryRead(MemRead),
  	.MemoryWrite(MemWrite),
  	.Clock(CLK)
  );
  
endmodule