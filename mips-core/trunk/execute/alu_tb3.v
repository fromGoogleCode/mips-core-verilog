`include "execute/alu.v"

module alu_tb3();

  // Re g i s t e r De c l a r a t i o n s
  reg [31:0] A,B ;
  reg [02 : 0] control ;
  // Wire P o r t s
  wire [31:0] result ;
  wire zero ;
  initial begin
    A <= 'b1010 ;
    B <= 'b0111 ;
    control <= 'b011 ;
    $display("A = %b\tB = %b" , A, B) ;
    $monitor("ALUOp = %b\t result = %b" , control , result ) ;
    #1
    control <= 'b100 ;
    #1
    control <= 'b010 ;
    #1
    control <= 'b111 ;
    #1
    control <= 'b011 ;
    #1
    control <= 'b110 ;
    #1
    control <= 'b001 ;
    #1
    control <= 'b000 ;
    #1
    $finish ;
  end
  alu alu(
  	.EX_rd1(A),
  	.EX_alu_in2(B),
  	.EX_alu_select(control),
  	.EX_alu_out(result),
  	.EX_alu_zero(zero)
  );
  //ALU ALU1( result , zero , A, B, control ) ;
endmodule // t e s t