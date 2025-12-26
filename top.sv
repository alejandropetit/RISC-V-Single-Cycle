module top(input logic clk, nrset);
	logic reset;
	assign reset = ~nreset;
endmodule