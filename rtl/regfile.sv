module regfile #(parameter XLEN = 32)(input logic clk, reset, we, input logic [4:0] r1, r2, r3, input logic [XLEN-1:0] w3, output logic [XLEN-1:0] s1, s2);
	logic [XLEN-1:0] rf [31:0];
	
	initial
		rf[0] = 0;
	
	assign s1 = rf[r1];
	assign s2 = rf[r2];
	always_ff @(posedge clk)
		if(we && r3) rf[r3] <= w3;	
endmodule

