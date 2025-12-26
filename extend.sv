module extend (input logic [1:0] i, input logic [19:0] instr, output logic [31:0] ext);
	always_comb
		case(i)
			2'b00: ext = {{20{instr[31]}},instr[19:8]};
			2'b01: ext = {{12{instr[31]}},instr};	
			2'b10: ext = {28'b0,instr[12:8]};
			default: ext = 32'bx;
		endcase
endmodule