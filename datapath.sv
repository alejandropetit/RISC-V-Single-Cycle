module datapath #(parameter XLEN = 32)(input logic clk, reset, SrcBCtrl, input logic [3:0] AluCtrl, input logic [1:0] ExtCtrl, input logic [XLEN-1:0] Instr, output logic [XLEN-1:0] PC);
	
	logic [XLEN-1:0] NextPC, SrcA, SrcB, Rsig2, AluResult, ExtImm;
	
	
	flopr #(XLEN) PCFlop(.d(NextPC), .q(PC), .clk(clk), .reset(reset));
	
	adder #(XLEN) add4(.a(PC), .b(4), .y(NextPC));
	
	regfile #(XLEN) rf(.r1(Instr[19:15]), .r2(Instr[24:20]), .r3(Instr[11:7]), .s1(SrcA), .s2(Rsig2), .w3(AluResult), .clk(clk));
	
	extend ext(.Instr(Instr[31:20]), .Ext(ExtImm), .i(ExtCtrl));
	
	mux2 #(XLEN) SrcBMux(.d0(Rsig2), .d1(ExtImm), .s(SrcBCtrl), .y(SrcB));
	
	alu #(XLEN) alu(.a(SrcA), .b(SrcB), .OP(AluCtrl), .y(AluResult));
	
	
endmodule