`ifndef _datamemory_v_
`define _datamemory_v_
`endif



module DataMemory ( ReadData , Address , WriteData , MemoryRead , MemoryWrite , Clock ) ;

  parameter DataMemory_Size = 256;              // in bytes

  output reg [31:0] ReadData;
  input wire [5:0] Address; 
  input wire [31:0] WriteData;
  input wire MemoryRead, MemoryWrite, Clock;
  
  reg [31:0] data [DataMemory_Size/4:0];        // The actual stored data
  
  always @(posedge Clock) begin                             
    if (MemoryRead)
      ReadData <= data[Address];                
    else
      ReadData <= ReadData;                     // If read enable is low, retain previous value
  
  end
  
  always @(negedge Clock) begin                  // Writes synchronous with negedge Clock
    if (MemoryWrite)
      data[Address] <= WriteData;  
  end  
    

endmodule