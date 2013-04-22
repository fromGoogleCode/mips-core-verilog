`include "execute/alu.v"

module alu_tb();

  reg [31:0] EX_rd1, EX_alu_in2;
  reg [2:0] EX_alu_select;
  wire [31:0] EX_alu_out;
  wire EX_alu_zero;
  
  alu alu(
  	.EX_rd1(EX_rd1),
  	.EX_alu_in2(EX_alu_in2),
  	.EX_alu_select(EX_alu_select),
  	.EX_alu_out(EX_alu_out),
  	.EX_alu_zero(EX_alu_zero)
  );

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, alu_tb);
    
    // ADD=010, SUB=110
  
    // Test ADD
    EX_rd1 = 32'd10; EX_alu_in2 = 32'd2; EX_alu_select = 3'b010; // 10 + 2    
    #2
    EX_rd1 = 32'd10; EX_alu_in2 = 32'd12; EX_alu_select = 3'b010; // 10 + 12
    #2
    EX_rd1 = 32'd10; EX_alu_in2 = 32'd2; EX_alu_select = 3'b110; // 10 - 2  
    #2
    EX_rd1 = 32'd10; EX_alu_in2 = 32'd12; EX_alu_select = 3'b110; // 10 - 12
  
    // Test SUB
    #2 
    EX_rd1 = -32'd10; EX_alu_in2 = 32'd2; EX_alu_select = 3'b010; // -10 + 2    
    #2
    EX_rd1 = -32'd10; EX_alu_in2 = 32'd12; EX_alu_select = 3'b010; // -10 + 12
    #2
    EX_rd1 = -32'd10; EX_alu_in2 = 32'd2; EX_alu_select = 3'b110; // -10 - 2  
    #2
    EX_rd1 = -32'd10; EX_alu_in2 = 32'd12; EX_alu_select = 3'b110; // -10 - 12
 
    // Test SLT   
    #2
    EX_rd1 = 32'd10; EX_alu_in2 = 32'd12; EX_alu_select = 3'b111;  // 10 < 12
    #2
    EX_rd1 = 32'd10; EX_alu_in2 = 32'd2; EX_alu_select = 3'b111;  //  10 >  2
    #2
    EX_rd1 = 32'd10; EX_alu_in2 = -32'd2; EX_alu_select = 3'b111;  // 10 > -2
    #2
    EX_rd1 = -32'd10; EX_alu_in2 = 32'd2; EX_alu_select = 3'b111; // -10 <  2
    #2
    EX_rd1 = -32'd10; EX_alu_in2 = -32'd2; EX_alu_select = 3'b111; //-10 < -2
    #2
    EX_rd1 = -32'd10; EX_alu_in2 = -32'd12; EX_alu_select = 3'b111;//-10 > -12
    
    
    // Test Zero
    #2
    EX_rd1 = 32'd10; EX_alu_in2 = 32'd10; EX_alu_select = 3'b110; //  10 - 10
    #2
    EX_rd1 = -32'd10; EX_alu_in2 = -32'd10; EX_alu_select = 3'b110;// -10 - -10
    
  
  
    #10 $finish;
  end

endmodule