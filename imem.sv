module imem #(parameter XLEN = 32) (input logic [XLEN-1:0] r, output logic [XLEN-1:0] s);
	logic [XLEN-1:0] RAM [255:0];	
	
	initial
		$readmemh("C:/Users/josea/RISC-V/RISC-V-Single-Cycle/imem.dat", RAM);
	
	assign s = RAM[r[31:2]];
endmodule