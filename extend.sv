module extend (input logic [1:0] i, input logic [19:0] Instr, output logic [31:0] Ext);
	always_comb
		case(i)
			2'b00: Ext = {{20{Instr[19]}},Instr[19:8]};
			2'b01: Ext = {Instr,12'b0};	
			2'b10: Ext = {27'b0,Instr[12:8]};
			default: Ext = 32'bx;
		endcase
endmodule