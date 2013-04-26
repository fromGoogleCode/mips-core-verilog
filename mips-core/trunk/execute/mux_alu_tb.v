`include "execute/mux_alu.v"

module mux_alu_tb();

  reg [31:0] EX_rd2=0, EX_imm=0;
  reg EX_alu_src=0;
  wire [31:0] EX_alu_in2;

  mux_alu mux_alu(
  	.EX_rd2(EX_rd2),
  	.EX_imm(EX_imm),
  	.EX_alu_src(EX_alu_src),
  	.EX_alu_in2(EX_alu_in2)
  );
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, mux_alu_tb);
    
    #2 EX_rd2 = 32'h0F; EX_imm = 32'h1F;
    #5 EX_alu_src = 1;
    
    #10 $finish;
  end

endmodule