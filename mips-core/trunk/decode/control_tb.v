`include "decode/control.v"

module control_tb();

  reg [5:0] opcode;
  wire [3:0] ID_ctlex;
  wire [2:0] ID_ctlm;
  wire [1:0] ID_ctlwb;
  
  control control_0(
  	.opcode(opcode),
  	.ID_ctlwb(ID_ctlwb),
  	.ID_ctlm(ID_ctlm),
  	.ID_ctlex(ID_ctlex)
  );
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, control_tb);
    
    opcode = 6'h00;
    #1 opcode = 6'h22;
    #1 opcode = 6'h23;
    #1 opcode = 6'h24;
    #1 opcode = 6'h2a;
    #1 opcode = 6'h2b;
    #1 opcode = 6'h2c;
    #1 opcode = 6'h03;
    #1 opcode = 6'h04;
    #1 opcode = 6'h05;
  
    #5 $finish;
  end
  
endmodule