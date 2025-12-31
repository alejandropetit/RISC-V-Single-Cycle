module top #(parameter XLEN = 32) (input logic clk, nreset);
	logic reset;
	assign reset = ~nreset;
	
	logic [XLEN-1:0] PC, Instr, AluResult, MemRead, Rsig2 ;
	logic wme;
	
	
	imem #(XLEN) imem (.r(PC), .s(Instr));
	
	riscv #(XLEN) riscv(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluResult(AluResult), .MemRead(MemRead), .Rsig2(Rsig2), .wme(wme));
	
	dmem #(XLEN) dmem (.clk(clk), .r(AluResult), .s(MemRead), .w(Rsig2), .MemMode(Instr[14:12]), .wme(wme));
	
endmodule