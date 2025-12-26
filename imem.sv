module imem #(parameter XLEN = 32) (input logic r, output logic s);
	logic [XLEN-1:0] RAM [255:0];	
	
	initial
		$readmemh("C:/Users/josea/RISC-V/RISC-V-Single-Cycle/imem.dat", RAM);
	
	assign s = RAM[r];
endmodule