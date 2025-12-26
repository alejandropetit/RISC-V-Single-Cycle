module mux2 #(parameter XLEN = 32)(input logic s, input logic [XLEN-1:0] d0, d1, output logic [XLEN-1:0] y);
	assign y = s ? d1 : d0;
endmodule