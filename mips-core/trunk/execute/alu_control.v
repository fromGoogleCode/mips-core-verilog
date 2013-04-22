`ifndef _alu_control_v_
`define _alu_control_v_
`endif

module alu_control(EX_funct, EX_alu_op, EX_alu_select);

  input wire [5:0] EX_funct;
  input wire [1:0] EX_alu_op;
  output reg [2:0] EX_alu_select;

  always @ (EX_funct or EX_alu_op) begin
    case(EX_alu_op)
      2'b00:   EX_alu_select = 3'b010;
      2'b01:   EX_alu_select = 3'b110;
      2'b10:   EX_alu_select = {
                   EX_funct[1],
                   ~EX_funct[2],
                   EX_funct[0] | EX_funct[3]
                   };
      default: EX_alu_select = 3'b000;
    endcase
  end

endmodule