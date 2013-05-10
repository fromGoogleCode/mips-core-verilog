`ifndef _singlecycleproc_v_
`define _singlecycleproc_v_
`endif

`ifndef _alu_v_
`include "hw/ALU.v"
`endif

`ifndef _alucontrol_v_
`include "hw/ALUControl.v"
`endif

`ifndef _datamemory_v_
`include "hw/DataMemory.v"
`endif

`ifndef _registerfile_v_
`include "hw/RegisterFile.v"
`endif

`ifndef _singlecyclecontrol_v_
`include "hw/SingleCycleControl.v"
`endif

module SingleCycleProc(CLK, Reset_L, startPC, dMemOut);

  input wire CLK;
  input wire Reset_L;
  input wire [31:0] startPC;
  input wire [31:0] dMemOut;


endmodule