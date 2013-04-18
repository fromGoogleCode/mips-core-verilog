`include "add16pg.v"

module add16pg_tb();

  reg [15:0] a,b;
  reg cin;
  wire [15:0] s;
  wire PG, GG;
  
  add16pg add16pg_test(.a(a), .b(b), .cin(cin), .s(s), .PG(PG), .GG(GG));
  
  reg clk = 0;
  wire [15:0] s_bh;
  reg s_tautology;
  
  always 
    #1 clk = !clk;
  
  always
    #2 a = {$random} % 65536;
    
  always
    #2 b = {$random} % 65536;

  always
    #2 cin = {$random} % 2;
        
  assign s_bh = a + b + cin; 
    
  always @(posedge clk)
    s_tautology <= s == s_bh;  
    
  always @(s_tautology)
        $display("%t %m : s_tautology = %b", $time, s_tautology);
    

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, add16pg_tb);
    
  
    #208000 $finish;
  end
  
endmodule