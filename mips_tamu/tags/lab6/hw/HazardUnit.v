`define _hazardunit_v_

module HazardUnit (IF_write, PC_write, bubble, addrSel, Jump, Branch, ALUZero,
                   memReadEX, currRs, currRt, prevRt, UseShamt, UseImmed, Clk, Rst);
  output reg IF_write, PC_write, bubble;
  output reg [1:0] addrSel;
  input wire Jump, Branch, ALUZero, memReadEX, Clk, Rst;
  input wire UseShamt, UseImmed;
  input wire [4:0] currRs, currRt, prevRt;
  
  // Determine if a load hazard exists
  wire LH_Rs = (currRs == prevRt) & (~UseShamt) & memReadEX;    // memReadEX will be high only for Load instructions
  wire LH_Rt = (currRt == prevRt) & (~UseImmed) & memReadEX;
  wire LdHazard = LH_Rs | LH_Rt; 

  // Finite State Machine
  reg [1:0] state, next_state;
  parameter NoHazard_state=0, Jump_state=1, Branch0_state=2, Branch1_state=3;
  
  // FSM output logic
  always @(*) begin
    case(state)
      NoHazard_state: begin
                        IF_write = ~LdHazard;  // Default values for these signals is 110 and will invert to 001 during a load hazard
                        PC_write = (~LdHazard) & (~Branch);  // This will stall the IF and ID stages for 1 clock, allowing the load to enter MEM stage. The no-op inserted
                        bubble   =  LdHazard;  // into the EX stage will set memReadEX to zero and therefore LdHazard to zero, resulting in a one cycle stall
                        addrSel  = (Jump) ? (2'b01) : (2'b00);  // Mux in jumpTarget if the instruction is decode stage is jmp
                      end
      Jump_state:     begin
                        IF_write = 1'b1;       // 
                        PC_write = 1'b1;       // 
                        bubble   = 1'b1;       // Insert bubble to squash (PC+4) instruction
                        addrSel  = 2'b00;      // 
                      end
      Branch0_state:  begin
                        IF_write = 1'b1;       // 
                        PC_write = 1'b1;       // 
                        bubble   = 1'b1;       // Replace instruction in ID with no-op
                        addrSel  = (ALUZero) ? (2'b10) : (2'b00);     // If branch is taken, fetch from branch target
                      end
      Branch1_state:  begin // This state only occurs if the branch is not taken
                        IF_write = 1'b1;
                        PC_write = 1'b1;
                        bubble   = 1'b1;       // Replace instruction in ID with no-op
                        addrSel  = 2'b00;
                      end
      default:        begin
                        IF_write = 1'b1;
                        PC_write = 1'b1;
                        bubble   = 1'b0;
                        addrSel  = 2'b0;
                      end
    endcase
  
  end
  
  
  // FSM next state logic
  always @(*) begin
    case(state)
      NoHazard_state: begin
                        if (Branch)
                          next_state = Branch0_state;
                        else if (Jump)
                          next_state = Jump_state;
                        else
                          next_state = NoHazard_state;
                      end
      Jump_state:     begin
                        next_state = NoHazard_state;
                      end
      Branch0_state:  begin
                        next_state = (ALUZero) ? (Branch1_state) : (NoHazard_state);
                      end
      Branch1_state:  begin 
                        next_state = NoHazard_state;
                      end
      default:        begin
                        next_state = NoHazard_state;
                      end   
    endcase
  end
  
  
  // FSM state update   
  always @ (negedge Clk) begin
    if (Rst)   // Active Low Reset
      state <= next_state;
    else
      state <= NoHazard_state;      
  end   

endmodule