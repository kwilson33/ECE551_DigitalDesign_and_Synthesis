module oscillator_tb();

reg clk, rst_n;
reg EN, OUT;

// Instantiate DUT //
oscillator iDUT(.clk(clk), .rst_n(rst_n), .en(EN), .OUT(OUT));

initial begin
  clk = 0;
  rst_n = 0;				// assert reset
  en = 0;					// start with it disabled
  @(posedge clk);			// wait one clock cycle
  @(negedge clk) rst_n = 1;	// deassert reset on negative edge (typically good practice)
  repeat (5)@(posedge clk);	// wait 5 clock cycles
  en = 1;					// stop counting
  repeat (10)@(posedge clk);	// wait 5 clock cycles
end

always
  #5 clk = ~clk;

endmodule  