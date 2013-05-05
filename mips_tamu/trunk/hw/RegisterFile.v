`ifndef _registerfile_v_
`define _registerfile_v_
`endif

// 32 by 32 register File. Two read ports, one write port
module RegisterFile (BusA , BusB , BusW, RA, RB, RW, RegWr , Clk ) ;

  output wire [31:0] BusA, BusB;   // Output read data port A and B
  input wire [31:0] BusW;          // Input write data
  input wire [4:0] RA, RB, RW;     // Read and Write register select
  input wire RegWr;                // Write enable, active high 
  input wire Clk;                  // Register write on negedge clk
  
  reg [31:0] rf [31:0];            // The actual data storage elements
  initial rf[0] <= 0;              // Hard wire R0 = 0;
  
  wire WriteAddressValid = |RW;     // May only write to R1-R31
  wire RegWrValid = RegWr & WriteAddressValid;

  assign BusA = rf[RA];            // Asynchronous read port A
  assign BusB = rf[RB];            // Asynchronous read port B
  
  always @(negedge Clk)            // Synchronous write port W
  begin
    if (RegWrValid)                // Only write if Write is Enabled
      rf[RW] <= BusW;              // and we are not writing to R0
  end

endmodule