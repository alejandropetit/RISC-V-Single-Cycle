module alu #(parameter XLEN = 32)(input logic [3:0] OP, input logic [XLEN-1:0] a, b, output logic [XLEN-1:0] y);
	always_comb	begin
		case(OP)
			4'b0000, 4'b0001: y = a + (OP[0] ? ~b : b) + OP[0]  ; 
			4'b0010: y = a << b ;
			4'b0011: y = (signed'(a) < signed'(b)) ? 1 : 0;
			4'b0100: y = (a < b) ? 1 : 0;
		   4'b0101: y = a ^ b;
			4'b0110: y = signed'(a) >>> b;	
			4'b0111: y = a >> b;
			4'b1000: y = a | b;		
			4'b1001: y = a & b;
			4'b1010: y = b;
			default: y = b;
		endcase
	end
endmodule
