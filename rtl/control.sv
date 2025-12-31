module control #(parameter XLEN=32)(input logic clk, reset, input logic [XLEN-1:0] PC, Rsig1, Rsig2, Instr, output logic [3:0] AluCtrl, output logic [2:0] ExtCtrl, output logic SrcACtrl, SrcBCtrl, we, wme, PCSrc, link, ResultCtrl);

logic [2:0] funct3;
logic [3:0] OF;
logic PCS, cond, WriteReg;
typedef enum logic[4:0] {OP = 5'b01100, OPIMM = 5'b00100, LUI = 5'b01101, AUIPC = 5'b00101, JAL = 5'b11011, JALR = 5'b11001, BRANCH = 5'b11000, LOAD = 5'b00000, STORE = 5'b01000} opcode_t;


opcode_t OPCODE;

always_comb begin
	case(OPCODE)
		OPIMM, OP:
			begin
				OF = {1'b0,funct3};
				if (OPCODE == OPIMM){WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl,PCS, link, ResultCtrl,wme} = ( funct3 == 3'b101|| funct3 == 3'b001) ? 10'b1010100000 : 10'b1010000000;
				else {WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link, ResultCtrl, wme} = 10'b1000000000;
			end
		LUI, AUIPC: 
			begin
				OF = (OP == LUI) ? 4'b1000 : 4'b1001;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link, ResultCtrl,wme} = 10'b1110010000;
			end
		JAL, JALR, BRANCH:
			begin
				OF = 4'b1010;
				if(OPCODE == JAL) {WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link, ResultCtrl,wme} = 10'b1110111100;
				else if(OPCODE == JALR) {WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link, ResultCtrl,wme} = 10'b1011001100;
				else {WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link,ResultCtrl,wme} = 10'b1111011100; 
			end
		LOAD, STORE:
			begin
				OF = 4'b1011;
				if(OPCODE == LOAD) {WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link,ResultCtrl,wme} = 10'b1010000010;
				else {WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link,ResultCtrl,wme} = 10'b0011100011;
			end
		default:
			begin
				OF = 4'bx;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link,ResultCtrl,wme} = 10'bx;
			end
	endcase
end

always_comb begin
	case(OF)
		4'b0000: if(Instr[30] && OPCODE == 5'b01100) AluCtrl = 4'b0001;
				   else AluCtrl = 4'b0000;
		4'b0001: AluCtrl = 4'b0010;//slli
		4'b0010: AluCtrl = 4'b0011;//slt
		4'b0011: AluCtrl = 4'b0100;//sltu
		4'b0100: AluCtrl = 4'b0101;//xori
		4'b0101: if(Instr[30]) AluCtrl = 4'b0110; //srai
					else AluCtrl = 4'b0111;//srli
		4'b0110: AluCtrl = 4'b1000;//ori
		4'b0111: AluCtrl = 4'b1001;//andi
		4'b1000: AluCtrl = 4'b1010;
		4'b1001, 4'b1010, 4'b1011: AluCtrl = 4'b0000;
		default: AluCtrl = 4'bx;
	endcase
end


always_comb begin
	if(OPCODE == BRANCH)
		case(funct3)
			3'b000, 3'b001: cond = funct3[0] ^ (Rsig1 == Rsig2);
			3'b100, 3'b110: cond = funct3[1] ? Rsig1 < Rsig2 : $signed(Rsig1) < $signed(Rsig2);
		   3'b101, 3'b111: cond = funct3[1]? Rsig1 >= Rsig2 : $signed(Rsig1) >= $signed(Rsig2);
		default: cond = 1'bx;	
		endcase
	else
		cond = 1'b1;
end


assign funct3 = Instr[14:12];
assign we = WriteReg & cond;
assign PCSrc = PCS & cond;
assign OPCODE = opcode_t'(Instr[6:2]);




endmodule