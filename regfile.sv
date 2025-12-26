module regfile #(parameter XLEN = 32)(input logic clk, reset, we, input logic [XLEN-1:0] r1, r2, r3, w3, output logic [XLEN-1:0] s1, s2);
	logic [XLEN-1:0] rf [31:0];
	assign s1 = r1;
	assign s2 = r2;
	always_ff @(posedge clk)
		if(we) rf[r3] <= w3;	
endmodule

