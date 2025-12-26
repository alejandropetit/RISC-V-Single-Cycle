module riscv #(parameter XLEN = 32) (input logic clk, reset, input logic [XLEN-1:0] PC, Instr);

	logic AluCtrl; 
	logic ExtCtrl; 
	logic SrcBCtrl;
	
	datapath #(XLEN) dp(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcBCtrl(SrcBCtrl));
	
	control #(XLEN) c(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcBCtrl(SrcBCtrl));
	
endmodule