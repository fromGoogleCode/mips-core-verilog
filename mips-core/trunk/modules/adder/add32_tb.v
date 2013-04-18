`include "add32.v"

module add32pg_tb();

  reg [31:0] a,b;
  reg cin;
  wire [31:0] s;
  wire cout;
  
  add32 add32_0(
        .a(a), 
        .b(b), 
        .cin(cin), 
        .s(s), 
        .cout(cout)
        );
  
  reg clk = 0;
  wire [31:0] s_bh;
  reg s_tautology;
  
  always 
    #1 clk = !clk;
  
  always
    #2 a = {$random} % 4294967296;
    
  always
    #2 b = {$random} % 4294967296;

  always
    #2 cin = {$random} % 2;
        
  assign s_bh = a + b + cin; 
    
  always @(posedge clk)
    s_tautology <= s == s_bh;  
    
  always @(s_tautology)
        $display("%t %m : s_tautology = %b", $time, s_tautology);
    

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, add32pg_tb);
    
  
    #20800 $finish;
  end
  
endmodule