`ifndef _alucontrol_v_
`define _alucontrol_v_
`endif

`define SLLFunc  6'b000000
`define SRLFunc  6'b000010
`define SRAFunc  6'b000011
`define ADDFunc  6'b100000
`define ADDUFunc 6'b100001
`define SUBFunc  6'b100010
`define SUBUFunc 6'b100011
`define ANDFunc  6'b100100
`define ORFunc   6'b100101
`define XORFunc  6'b100110
`define NORFunc  6'b100111
`define SLTFunc  6'b101010
`define SLTUFunc 6'b101011

module ALUControl(ALUCtrl, ALUop, FuncCode);

  output wire [3:0] ALUCtrl;
  input wire [3:0] ALUop;
  input wire [5:0] FuncCode;

endmodule