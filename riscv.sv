module riscv #(parameter XLEN = 32) (input logic clk, reset, input logic [XLEN-1:0] Instr, output logic [XLEN-1:0] PC);

	logic [3:0] AluCtrl; 
	logic [1:0] ExtCtrl; 
	logic SrcACtrl, SrcBCtrl, we;
	
	datapath #(XLEN) dp(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcACtrl(SrcACtrl), .SrcBCtrl(SrcBCtrl), .we(we));
	
	control #(XLEN) c(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcACtrl(SrcACtrl), .SrcBCtrl(SrcBCtrl), .we(we));
	
endmodule