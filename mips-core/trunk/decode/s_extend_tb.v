`include "decode/s_extend.v"

module s_extend_tb();

  reg [15:0] imm;
  wire [31:0] ID_imm;
  
  s_extend s_extend(
  	.imm(imm),
  	.ID_imm(ID_imm)
  );
  
  always
    #2 imm = ($random) % 65536;

  always @(imm)
    $display("%b ---> %b", imm, ID_imm); 
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, s_extend_tb);
  
    #40 $finish;
  end

endmodule