module control #(parameter XLEN=32)(input logic clk, reset, input logic [XLEN-1:0] PC, Instr, output logic [3:0] AluCtrl, output logic [1:0] ExtCtrl, output logic SrcACtrl, SrcBCtrl, we);

logic [3:0] funct, OF;
logic [4:0] OP;

always_comb begin
	case(OP)
		5'b00100:
			begin
				OF = 4'bxxxx;
				{we, SrcACtrl, SrcBCtrl} = 3'b101;
				ExtCtrl = ( Instr[14:12] == 3'b101|| Instr[14:12] == 3'b001) ? 2'b10 : 2'b00;
			end
		5'b01101, 5'b00101: 
			begin
				OF = (OP == 5'b01101) ? 4'b1000 : 4'b1001;
				{we, SrcACtrl, SrcBCtrl, ExtCtrl} = 5'b11101;
			end
		5'b01100: 
			begin
				OF = 4'bxxxx;
				{we, SrcACtrl, SrcBCtrl, ExtCtrl} = 5'b10000;// 
			end
		default:
			begin
				OF = 4'bxxxx;
				ExtCtrl = 2'bxx;
				{we, SrcACtrl, SrcBCtrl, ExtCtrl} = 5'bxxxxx;
			end
	endcase
end

always_comb begin
	case(funct)
		4'b0000: if(Instr[30] && OP == 5'b01100) AluCtrl = 4'b0001;
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
		default: AluCtrl = 4'bxxxx;
	endcase
end


assign OP = Instr[6:2];
assign funct = (OP == 5'b00100 || OP == 5'b01100) ? {1'b0,Instr[14:12]} : OF;



endmodule