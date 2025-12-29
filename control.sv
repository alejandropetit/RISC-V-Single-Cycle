module control #(parameter XLEN=32)(input logic clk, reset, input logic [XLEN-1:0] PC, Rsig1, Rsig2, Instr, output logic [3:0] AluCtrl, output logic [2:0] ExtCtrl, output logic SrcACtrl, SrcBCtrl, we, PCSrc, link);

logic [3:0] funct, OF;
logic PCS, cond, WriteReg, fig, fag;
typedef enum logic[4:0] {OP = 5'b01100, OPIMM = 5'b00100, LUI = 5'b01101, AUIPC = 5'b00101, JAL = 5'b11011, JALR = 5'b11001, BRANCH = 5'b11000} opcode_t;


opcode_t OPCODE;

always_comb begin
	case(OPCODE)
		OPIMM:
			begin
				OF = 4'bxxxx;
				{WriteReg, SrcACtrl, SrcBCtrl, PCS, link} = 5'b10100;
				ExtCtrl = ( Instr[14:12] == 3'b101|| Instr[14:12] == 3'b001) ? 3'b010 : 3'b000;
			end
		LUI, AUIPC: 
			begin
				OF = (OP == 5'b01101) ? 4'b1000 : 4'b1001;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link} = 8'b11100100;
			end
		OP: 
			begin
				OF = 4'bxxxx;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link} = 8'b10000000;// 
			end
		JAL:
			begin
				OF = 4'b1010;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link} = 8'b11101111;
			end
		JALR:
			begin
				OF = 4'b1010;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link} = 8'b10110011;
			end
		BRANCH:
			begin
				OF = 4'b1010;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link} = 8'b11110111; 
			end
		default:
			begin
				OF = 4'bxxxx;
				ExtCtrl = 3'bxxx;
				{WriteReg, SrcACtrl, SrcBCtrl, ExtCtrl, PCS, link} = 8'bxxxxxxxx;
			end
	endcase
end

always_comb begin
	case(funct)
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
		4'b1001: AluCtrl = 4'b0000;
		4'b1010: AluCtrl = 4'b0000;
		default: AluCtrl = 4'bxxxx;
	endcase
end

always_comb begin
	if(OPCODE == BRANCH) begin
		case(Instr[14:12])
			3'b000, 3'b001: cond = Instr[12] ^ (Rsig1 == Rsig2);
			3'b100, 3'b110: cond = Instr[13] ? Rsig1 < Rsig2 : $signed(Rsig1) < $signed(Rsig2);
		   3'b101, 3'b111: cond = Instr[13] ? Rsig1 >= Rsig2 : $signed(Rsig1) >= $signed(Rsig2);
		default: cond = 1'bx;	
		endcase
	end
	else
		cond = 1'b1;

end

assign fig = (Rsig1 == Rsig2);
assign fag = funct[0];
assign we = WriteReg & cond;
assign PCSrc = PCS & cond;
assign OPCODE = opcode_t'(Instr[6:2]);
assign funct = (OPCODE == 5'b00100 || OPCODE == 5'b01100) ? {1'b0,Instr[14:12]} : OF;



endmodule