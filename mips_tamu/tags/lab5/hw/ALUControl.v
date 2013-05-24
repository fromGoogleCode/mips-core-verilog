`ifndef _alucontrol_v_
`define _alucontrol_v_
`endif

`ifndef _alu_v_
`include "hw/ALU.v" 
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

  output wire [3:0] ALUCtrl;  // Control signals sent to ALU
  input wire [3:0] ALUop;     // Control signals generated from Control Unit
  input wire [5:0] FuncCode;  // Bits from an R-Type instruction which specify the arithmetic or logic operation for instruction

  wire op_select;             // Select signal for output multiplexer
  reg [3:0] decoded_FuncCode;// Control signals generated from instruction FuncCode field

  assign op_select = & ALUop; // Only select decoded_FuncCode when ALUop = 1111;
  
  assign ALUCtrl = (op_select) ? (decoded_FuncCode) : (ALUop); // Output Mux
  
  // Generate control signals from FuncCode
  always @(*) begin
    case (FuncCode)
      `SLLFunc:  decoded_FuncCode = `SLL;
      `SRLFunc:  decoded_FuncCode = `SRL;
      `SRAFunc:  decoded_FuncCode = `SRA;
      `ADDFunc:  decoded_FuncCode = `ADD;
      `ADDUFunc: decoded_FuncCode = `ADDU;
      `SUBFunc:  decoded_FuncCode = `SUB;
      `SUBUFunc: decoded_FuncCode = `SUBU;
      `ANDFunc:  decoded_FuncCode = `AND;
      `ORFunc:   decoded_FuncCode = `OR;
      `XORFunc:  decoded_FuncCode = `XOR;
      `NORFunc:  decoded_FuncCode = `NOR;
      `SLTFunc:  decoded_FuncCode = `SLT;
      `SLTUFunc: decoded_FuncCode = `SLTU;
      default:   decoded_FuncCode = 4'bx;
    endcase
  end

endmodule