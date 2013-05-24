`define _if_id_v_


module IF_ID(CLK, IF_write, IF_pc4, IF_IR, ID_pc4, ID_IR);

  input wire CLK, IF_write;
  input wire [31:0] IF_pc4, IF_IR;
  output reg [31:0] ID_pc4, ID_IR;
  
  always @ (negedge CLK) begin
    if (IF_write) begin
      ID_pc4 <= IF_pc4;
      ID_IR  <= IF_IR;
      end
    else begin
      ID_pc4 <= ID_pc4;
      ID_IR  <= ID_IR;
      end
  end

endmodule