module riscv #(parameter XLEN = 32) (input logic clk, reset, input logic [XLEN-1:0] Instr, output logic [XLEN-1:0] PC);

	logic [3:0] AluCtrl; 
	logic [2:0] ExtCtrl; 
	logic SrcACtrl, SrcBCtrl, we, link, PCSrc;
	logic [XLEN-1:0] Rsig1, Rsig2;
	
	datapath #(XLEN) dp(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcACtrl(SrcACtrl), .SrcBCtrl(SrcBCtrl), .we(we), .PCSrc(PCSrc), .link(link), .Rsig1(Rsig1), .Rsig2(Rsig2));
	
	control #(XLEN) c(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcACtrl(SrcACtrl), .SrcBCtrl(SrcBCtrl), .we(we), .PCSrc(PCSrc), .link(link), .Rsig1(Rsig1), .Rsig2(Rsig2));
	
endmodule