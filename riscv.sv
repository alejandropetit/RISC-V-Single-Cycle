module riscv #(parameter XLEN = 32) (input logic clk, reset, input logic [XLEN-1:0] Instr, MemRead, output logic wme,output logic [XLEN-1:0] PC, AluResult, Rsig2);

	logic [3:0] AluCtrl; 
	logic [2:0] ExtCtrl, MemMode; 
	logic SrcACtrl, SrcBCtrl, we, link, PCSrc, ResultCtrl;
	logic [XLEN-1:0] Rsig1;
	
	datapath #(XLEN) dp(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluResult(AluResult), .MemRead(MemRead), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcACtrl(SrcACtrl), .SrcBCtrl(SrcBCtrl), .we(we), .PCSrc(PCSrc), .link(link), .Rsig1(Rsig1), .Rsig2(Rsig2), .ResultCtrl(ResultCtrl), .wme(wme));
	
	control #(XLEN) c(.clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .AluCtrl(AluCtrl), .ExtCtrl(ExtCtrl), .SrcACtrl(SrcACtrl), .SrcBCtrl(SrcBCtrl), .we(we), .PCSrc(PCSrc), .link(link), .Rsig1(Rsig1), .Rsig2(Rsig2), .ResultCtrl(ResultCtrl), .wme(wme));
	
endmodule