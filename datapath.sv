module datapath #(parameter XLEN = 32)(input logic clk, reset,  SrcACtrl, SrcBCtrl, we, wme, PCSrc, link, ResultCtrl, input logic [3:0] AluCtrl, input logic [2:0] ExtCtrl, input logic [XLEN-1:0] Instr, MemRead, MemMode, output logic [XLEN-1:0] PC, Rsig1, AluResult, Rsig2);
	
	logic [XLEN-1:0] NextPC, SrcA, SrcB, ExtImm, PCp4, toWrite3, Result;
	
	
	mux2 #(XLEN) PCMux(.d0(PCp4),.d1(AluResult),.s(PCSrc),.y(NextPC));
	
	flopr #(XLEN) PCFlop(.d(NextPC), .q(PC), .clk(clk), .reset(reset));
	
	adder #(XLEN) add4(.a(PC), .b(4), .y(PCp4));
	
	mux2 #(XLEN) LinkMux(.d0(Result),.d1(PCp4),.s(link),.y(toWrite3));
	
	regfile #(XLEN) rf(.r1(Instr[19:15]), .r2(Instr[24:20]), .r3(Instr[11:7]), .s1(Rsig1), .s2(Rsig2), .w3(toWrite3), .clk(clk), .we(we));
	
	extend ext(.Instr(Instr[31:7]), .Ext(ExtImm), .i(ExtCtrl));
	
	mux2 #(XLEN) SrcAMux(.d0(Rsig1), .d1(PC), .s(SrcACtrl), .y(SrcA));
	
	mux2 #(XLEN) SrcBMux(.d0(Rsig2), .d1(ExtImm), .s(SrcBCtrl), .y(SrcB));
	
	alu #(XLEN) alu(.a(SrcA), .b(SrcB), .OP(AluCtrl), .y(AluResult));
	
	mux2 #(XLEN) ResultMux(.d0(AluResult), .d1(MemRead), .s(ResultCtrl), .y(Result));
	
	
	
endmodule