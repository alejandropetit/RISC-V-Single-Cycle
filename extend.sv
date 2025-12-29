module extend (input logic [2:0] i, input logic [31:6] Instr, output logic [31:0] Ext);
	always_comb
		case(i)
			3'b000: Ext = {{20{Instr[31]}},Instr[31:20]};
			3'b001: Ext = {Instr[31:12],12'b0};	
			3'b010: Ext = Instr[24:20];
			3'b011: Ext = {{11{Instr[31]}},Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0};
			3'b100: Ext = {{20{Instr[31]}},Instr[31:21], 1'b0};
			3'b101: Ext = {{19{Instr[31]}},Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};
			
			
			default: Ext = 32'bx;
		endcase
endmodule