`include "pg4.v"

module pg4_tb();

  wire [3:0] p,g;
  wire cin,PG,GG;
  reg [8:0] counter=0;
  reg clk=0;
  wire [3:1] c;
  wire [1:0] c1_test;
  wire c2_test;
  wire c3_test;
  wire c4_test;
  wire c1_eq, c2_eq, c3_eq, c4_eq;
  
  always
    #1 clk = !clk;
    
  always
    #2 counter = counter + 1;
    
  assign g = counter[3:0];
  assign p = counter[7:4];
  assign cin = counter[8];
  
  pg4 pg4_test(
        .cin(cin),
        .c(c),
        .p(p),
        .g(g),
        .PG(PG),
        .GG(GG)
        );
  
  //test c1 output
  assign c1_test = counter[8] + counter[4] + counter[0];
  assign c1_eq = c1_test[1] ~^ c[1];
    
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, pg4_tb);
    
    //$monitor("%0t %m cin: %b", $time, cin);
    //$monitor("%0t %m c1_eq: %b", $time, c1_eq);
    
    #2100 $finish;
  end

endmodule