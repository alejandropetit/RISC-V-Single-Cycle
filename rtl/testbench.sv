module testbench();
	logic clk, reset;
	
	localparam DELAY = 10;
	
	top dut(clk, reset);
	
	initial
	begin
		reset <= 0; #DELAY;
		reset <= 1; #(DELAY * 1000);
		
		$stop;
	end
	
	always
	begin
		clk <= 1; #(DELAY/2);
		clk <= 0; #(DELAY/2);
	end
endmodule