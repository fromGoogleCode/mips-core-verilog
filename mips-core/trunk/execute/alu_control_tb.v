`include "execute/alu_control.v"

module alu_control_tb();

  // Wire P o r t s
  wire [2:0] select ;
  // Re g i s t e r De c l a r a t i o n s
  reg [1:0] aluop ;
  reg [5:0] funct ;
  
  alu_control alu_control(
  	.EX_funct(funct),
  	.EX_alu_op(aluop),
  	.EX_alu_select(select)
  );
  
  initial begin
    aluop = 2'b00 ;
    funct = 6'b100000 ;
    $monitor ( "ALUOp = %b\t funct = %b\t select = %b " , aluop , funct ,select ) ;
    #1
    aluop = 2'b01 ;
    funct = 6'b100000 ;
    #1
    aluop = 2'b10 ;
    funct = 6'b100000 ;
    #1
    funct = 6'b100010 ;
    #1
    funct = 6'b100100 ;
    #1
    funct = 6'b100101 ;
    #1
    funct = 6'b101010 ;
    #1
    $finish;
  end
endmodule // t e s t
