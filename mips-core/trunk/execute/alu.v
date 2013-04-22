`ifndef _alu_v_
`define _alu_v_
`endif

`ifndef _add32_v_
`include "modules/adder/add32.v"
`endif

module alu(EX_rd1, EX_alu_in2, EX_alu_select, EX_alu_out, EX_alu_zero);

  input wire [31:0] EX_rd1, EX_alu_in2;
  input wire [2:0] EX_alu_select;
  output wire [31:0] EX_alu_out;
  output wire EX_alu_zero;
  
  wire [31:0] A, B, B_2, S, LT, A_or_B, A_and_B, arith_out, logic_out;
  wire negate_B, select_arithmetic, select_or, cout;

  //Decompose control signal
  assign negate_B = EX_alu_select[2];
  assign select_arithmetic = EX_alu_select[1];
  assign select_or = EX_alu_select[0];

  // ***** Start Arithmetic Part of ALU
 
  //Define inputs to adder
  assign A = EX_rd1;
  assign B = EX_alu_in2;
  assign B_2 = B ^ {32{negate_B}};  //If sub operation, then negate B to find 2s complement (and set cin = 1)
  
  add32 add32(
  	.a(A),
  	.b(B_2),
  	.cin(negate_B),
  	.s(S),
  	.cout(cout)
  );
  
  //Determine if A < B
  assign LT = {31'b0, 
        (A[31] & !B[31]) | (S[31] & (A[31] | !B[31])) };
        
  // Select output of Adder or Comparator
  assign arith_out = (select_or) ? LT : S;      
  
  assign EX_alu_zero = ~| S;
   
  // ***** End Arithmetic Part of ALU
  
    
  // ***** Start Logic Part of ALU
  
  assign A_or_B = A | B;
  assign A_and_B = A & B;
  
  assign logic_out = (select_or) ? A_or_B : A_and_B;
    
  // ***** End Logic Part of ALU

  assign EX_alu_out = (select_arithmetic) ? (arith_out) : (logic_out);

endmodule