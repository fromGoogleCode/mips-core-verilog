`ifndef _singlecyclecontrol_v_
`define _singlecyclecontrol_v_
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
             MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode);

  input wire [5:0] Opcode;
  output wire [3:0] ALUOp;
  output wire RegDst, ALUSrc1,ALUSrc2, MemToReg, RegWrite, 
             MemRead, MemWrite, Branch, Jump, SignExtend;

endmodule