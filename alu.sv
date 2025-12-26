module alu #(parameter XLEN = 32)(input logic [3:0] OP input logic [XLEN-1:0] a, b, output logic [XLEN-1:0] y);
	always_comb	begin
		y = a;
	end
endmodule
