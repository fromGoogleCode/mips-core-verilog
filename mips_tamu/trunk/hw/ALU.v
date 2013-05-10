`ifndef _alu_v_
`define _alu_v_
`endif

`define AND  4'b0000
`define OR   4'b0001
`define ADD  4'b0010
`define SLL  4'b0011
`define SRL  4'b0100
`define SUB  4'b0110
`define SLT  4'b0111
`define ADDU 4'b1000
`define SUBU 4'b1001
`define XOR  4'b1010
`define SLTU 4'b1011
`define NOR  4'b1100
`define SRA  4'b1101
`define LUI  4'b1110

module ALU(BusW, Zero, BusA, BusB, ALUCtrl);

  input wire [31:0] BusA, BusB;
  input wire [3:0] ALUCtrl;
  output wire [31:0] BusW;
  output wire Zero;

endmodule