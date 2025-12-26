module top #(parameter XLEN = 32) (input logic clk, nreset);
	logic reset;
	assign reset = ~nreset;
	
	logic [XLEN-1:0] PC, Instr;
	
	
	imem #(XLEN) imem (.r(PC), .s(Instr));
	
	riscv #(XLEN) riscv(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr));
	
endmodule