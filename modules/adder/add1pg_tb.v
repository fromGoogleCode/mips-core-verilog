`include "add1pg.v"

module add1pg_tb();

//reg a, b, c, clk=0;
reg clk=0;
reg [2:0] counter =0;
wire a,b,c,s, p, g;

add1pg add1pg_test(.a(a), .b(b), .c(c), 
                   .s(s), .p(p), .g(g));

always 
  #1 clk = !clk;
  
always
  #5 counter = counter+1;

assign a=counter[2];
assign b=counter[1];
assign c=counter[0];


  
initial begin
  $dumpfile("test.vcd");
  $dumpvars(0, add1pg_tb);
 
  #60 $finish;
end
  
endmodule