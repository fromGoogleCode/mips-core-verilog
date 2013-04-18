`include "add4pg.v"

module add4pg_tb();

  wire [3:0] a,b;
  wire cin;
  wire [3:0] s;
  wire PG, GG;
  
  add4pg add4pg_test(.a(a), .b(b), .cin(cin), .s(s), .PG(PG), .GG(GG));
  
  reg clk = 0;
  reg [8:0] counter = 0;
  wire [3:0] s_bh;
  reg s_tautology;
  
  always
    #1 clk = !clk;
    
  always
    #2 counter = counter + 1;
    
  assign cin = counter[8];
  assign a = counter[7:4];
  assign b = counter[3:0];  
    
  assign s_bh = a + b + cin; 
    
  always @(posedge clk)
    s_tautology <= s == s_bh;  
    
  always @(s_tautology)
        $display("%t %m : s_tautology = %b", $time, s_tautology);
    

  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, add4pg_tb);
    
  
    #2080 $finish;
  end
  
endmodule