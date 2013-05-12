`ifndef _alu_v_
`define _alu_v_
`endif

`define AND  4'b0000
`define OR   4'b0001
`define ADD  4'b0010
`define SLL  4'b0011
`define SRL  4'b0100
`define SUB  4'b0110
`define SLT  4'b0111  // Set less than
`define ADDU 4'b1000  // Add Unsigned
`define SUBU 4'b1001
`define XOR  4'b1010
`define SLTU 4'b1011
`define NOR  4'b1100
`define SRA  4'b1101
`define LUI  4'b1110

module ALU(BusW, Zero, BusA, BusB, ALUCtrl);

  input wire [31:0] BusA, BusB;
  input wire [3:0] ALUCtrl;
  output reg [31:0] BusW;
  output wire Zero;
  
  wire w_zero = ~(|BusW);   // Determine if BusW == 0
  assign Zero = w_zero;
  
  always @(*) begin
    case (ALUCtrl)
      `AND:  begin   // Bitwise And
              BusW= BusA & BusB;
              //Zero=1'bx;
            end
      `OR:  begin    // Bitwise OR
              BusW= BusA | BusB;
              //Zero=1'bx;
            end
      `ADD:  begin   // Add
              BusW= BusA + BusB;
              //Zero=1'bx;
            end
      `SLL:  begin   // Shift Left Logical
              BusW= (BusB << BusA);
              //Zero=1'bx;
            end
      `SRL:  begin   // Shift Right Logical
              BusW= (BusB >> BusA);
              //Zero=1'bx;
            end
      `SUB:  begin   // Subtraction
              BusW= BusA - BusB;
              //Zero=1'bx;
            end
      `SLT:  begin   // Set less than (A<B)
              BusW={31'b0, (BusA<BusB)};
              //Zero=1'bx;
            end
      `ADDU:  begin  // Unsigned Add 
              BusW= BusA + BusB;
              //Zero=1'bx;
            end
      `SUBU:  begin  // Unsigned Subtract
              BusW= BusA - BusB;
              //Zero=1'bx;
            end
      `XOR:  begin   // Bitwise XOR 
              BusW= BusA ^ BusB;
              //Zero=1'bx;
            end
      `SLTU:  begin  // Set Less Than unsigned
              BusW= {31'b0, (BusA<BusB)};
              //Zero=1'bx;
            end
      `NOR:  begin  // Bitwise NOR
              BusW= BusA ~| BusB;
              //Zero=1'bx;
            end
      `SRA:  begin  // Arithmetic Right Shift
              BusW= {{31{BusB[31]}},BusB} >> BusA;
              //Zero=1'bx;
            end
      `LUI:  begin  // Load upper immdediate
              BusW= {BusB[15:0], 16'b0};     // Immediate muxed into BusB
              //Zero=1'bx;
            end            
      default: begin
                 BusW=32'bx;
                 //Zero=1'bx;
               end
    endcase
  
  end

endmodule