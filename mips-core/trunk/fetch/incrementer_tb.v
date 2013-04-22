`include "fetch/incrementer.v"


module incrementer_tb();

  reg [31:0] pcin;
  wire [31:0] pcout;
  
  incrementer incrementer_0 (.pcin(pcin), .pcout(pcout));
  
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, incrementer_tb);
    
    pcin = 32'd0;
    
    #5 pcin = 32'd30;
    #5 pcin = 32'd3;
    #5 pcin = 32'd200;
    #5 pcin = 32'd9996;
    
  
    #10 $finish;
  end

endmodule