`include "pg2.v"

module pg2_tb();

  wire [1:0] p,g;
  wire cin;
  reg [4:0] counter=0;
  reg clk=0;
  wire [2:1] c;
  
  always
    #1 clk = !clk;
    
  always
    #2 counter = counter + 1;
    
  assign g = counter[1:0];
  assign p = counter[3:2];
  assign cin = counter[4];
  
  pg2 pg2_test(
        .cin(cin),
        .c(c),
        .p(p),
        .g(g)
        );
  
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, pg2_tb);
    
    //$monitor("%0t %m cin: %b", $time, cin);
    //$monitor("%0t %m c1_eq: %b", $time, c1_eq);
    
    #270 $finish;
  end

endmodule