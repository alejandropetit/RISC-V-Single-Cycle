module dmem #(parameter XLEN = 32)(input logic clk, wme, input logic [2:0] MemMode, input logic [XLEN-1:0] r,w, output logic [XLEN-1:0] s);

logic [XLEN-1:0] RAM [255:0];
logic [31:0] word,Aux;
logic [3:0] be;

initial
	$readmemh("C:/Users/josea/RISC-V/RISC-V-Single-Cycle/dmem.dat",RAM);




always_comb begin
	case(be)
		4'b1000: s = (MemMode[2])? RAM[r[31:2]][31:24]:{{24{RAM[r[31:2]][31]}},RAM[r[31:2]][31:24]};
		4'b0100: s = (MemMode[2])? RAM[r[31:2]][23:16]:{{24{RAM[r[31:2]][23]}},RAM[r[31:2]][23:16]};
		4'b0010: s = (MemMode[2])? RAM[r[31:2]][15:8]:{{24{RAM[r[31:2]][15]}},RAM[r[31:2]][15:8]};
		4'b0001: s = (MemMode[2])? RAM[r[31:2]][7:0]:{{24{RAM[r[31:2]][7]}},RAM[r[31:2]][7:0]};
		4'b1100: s = (MemMode[2])? RAM[r[31:2]][31:16]:{{16{RAM[r[31:2]][31]}},RAM[r[31:2]][31:16]};
		4'b0011: s = (MemMode[2])? RAM[r[31:2]][15:0]:{{16{RAM[r[31:2]][15]}},RAM[r[31:2]][15:0]};
		default: s = RAM[r[31:2]];
	endcase
end

always_comb begin
	be = 4'b0;
	
	case(MemMode[1:0])
		2'b01:
			be = r[1] ? 4'b1100 : 4'b0011;
		2'b00:
			be = 4'b0001 << r[1:0];
		default:
			be = 4'b1111;
	
	endcase
end

always_ff @(posedge clk) begin
	if(wme)
		case(be)
			4'b1000: RAM[r[31:2]][31:24] <= w[7:0] ;
			4'b0100: RAM[r[31:2]][23:16] <= w[7:0];
			4'b0010: RAM[r[31:2]][15:8] <= w[7:0];
			4'b0001: RAM[r[31:2]][7:0] <= w[7:0];
			4'b1100: RAM[r[31:2]][31:16] <= w[15:0];
			4'b0011: RAM[r[31:2]][15:0] <= w[15:0];
			default: RAM[r[31:2]] <= w;
		endcase
end


endmodule