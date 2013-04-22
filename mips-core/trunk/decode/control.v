`ifndef _control_v_
`define _control_v_
`endif

module control(opcode, ID_ctlwb, ID_ctlm, ID_ctlex);
  input wire [5:0] opcode;
  output reg [1:0] ID_ctlwb;
  output reg [2:0] ID_ctlm;
  output reg [3:0] ID_ctlex;

always @(opcode) begin

  case(opcode)
    6'h00:  begin // R-Type instruction
              ID_ctlex = 4'b1100;
              ID_ctlm  = 3'b000;
              ID_ctlwb = 2'b10;
            end
    6'h23:  begin // LW instruction
              ID_ctlex = 4'b0001;
              ID_ctlm  = 3'b010;
              ID_ctlwb = 2'b11;
            end
    6'h2b:  begin // SW instruction
              ID_ctlex = 4'b0001;
              ID_ctlm  = 3'b001;
              ID_ctlwb = 2'b00;
            end
    6'h04:  begin // BEQ instruction
              ID_ctlex = 4'b0010;
              ID_ctlm  = 3'b100;
              ID_ctlwb = 2'b00;
            end
    default:  begin
                ID_ctlex = 4'b0000;
                ID_ctlm  = 3'b000;
                ID_ctlwb = 2'b00;
              end
  endcase

end


endmodule