`ifndef _ex_mem_
`define _ex_mem_
`endif

module ex_mem(clk,
            EX_bpc, EX_alu_out, EX_rd2, EX_ctlwb, EX_ctlm, EX_alu_zero, EX_rd_mux,
            MEM_bpc, MEM_alu_out, MEM_rd2, MEM_ctlwb, MEM_ctlm, MEM_alu_zero, MEM_rd
            );
  input wire clk;          
            
  input wire [31:0] EX_bpc, EX_alu_out, EX_rd2;
  input wire [1:0] EX_ctlwb;
  input wire [2:0] EX_ctlm;
  input wire EX_alu_zero;
  input wire [4:0] EX_rd_mux;
  
  output reg [31:0] MEM_bpc, MEM_alu_out, MEM_rd2;
  output reg [1:0] MEM_ctlwb;
  output reg [2:0] MEM_ctlm;
  output reg MEM_alu_zero;
  output reg [4:0] MEM_rd;
  
  always @(posedge clk) begin
    MEM_bpc      <= EX_bpc;
    MEM_alu_out  <= EX_alu_out;
    MEM_rd2      <= EX_rd2;
    MEM_ctlwb    <= EX_ctlwb;
    MEM_ctlm     <= EX_ctlm;
    MEM_alu_zero <= EX_alu_zero;
    MEM_rd       <= EX_rd_mux;
  end

endmodule