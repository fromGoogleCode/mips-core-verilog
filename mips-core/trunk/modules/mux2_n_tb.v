//Filename:testmux.v
//Description: Testing the 32bit mux module
//of the IF stage of the pipeline.
`include "modules/mux2_n.v"

module mux2_n_tb();

  //WirePorts
  wire [31:0] Y;

  //RegisterDeclarations
  reg [31:0] A,B;
  reg sel;

  mux2_n #(32) mux1(A,B,sel,Y);//instantiatethemux

  initial begin
    A= 32'hAAAAAAAA;
    B=32'h55555555;
    sel=1'b1;
    #10;
    A=32'h00000000;
    #10
    sel=1'b1;
    #10;
    B=32'hFFFFFFFF;
    #5;
    A=32'hA5A5A5A5;
    #5;
    sel=1'b0;
    B=32'hDDDDDDDD;
    #5;
    sel=1'bx;
  end
  
  always@(A or B or sel)
    #1 $display("Att = %0d sel = %b A = %h B = %h Y = %h", $time,sel,A,B,Y);
endmodule//test