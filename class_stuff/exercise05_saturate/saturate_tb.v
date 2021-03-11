module saturate_tb();
	//Kevin Wilson
	
	reg [15:0] unsigned_err_STIM;
	reg [15:0] signed_err_STIM;
	reg [9:0]  signed_D_diff_STIM;

	
	wire [9:0] unsigned_err_sat_OUT;
	wire [9:0] signed_err_sat_OUT;
	wire [6:0] signed_D_diff_sat_OUT;
	
	
	//Instantiate DUT//
	saturate iDUT(.unsigned_err_sat(unsigned_err_sat_OUT), .signed_D_diff_sat(signed_D_diff_sat_OUT),
				  .signed_err_sat(signed_err_sat_OUT), .unsigned_err(unsigned_err_STIM), 
				  .signed_D_diff(signed_D_diff_STIM), .signed_err(signed_err_STIM));
				  
	initial begin
		$monitor("At = %t: \n unsigned_err_sat = %h \nsigned_err_sat = %h \n signed_D_diff_sat = %h",
$time,unsigned_err_sat_OUT, signed_err_sat_OUT, signed_D_diff_sat_OUT);
		unsigned_err_STIM = 0;
		signed_D_diff_STIM = 0;
		signed_err_STIM = 0;
		#5
		$stop();
		
		// unsigned err should stay the same. Use (largest num -1 = 1023, 3FE) can rep with 10 bits
		// signed err should stay the same. Use (largest num -1 = 510, 1FE) can rep with signed 10 bits
		// signed D diff should stay the same. Use (largest num -1 = 62,3E) can rep with signed 7 bits
		unsigned_err_STIM = 16'h3FE;
		signed_err_STIM = 16'h1FE;
		signed_D_diff_STIM = 10'h3E;
		#5
		$stop();
		
		// unsigned err should saturate, too positive
		// signed err should saturate, too positive
		// signed D diff should saturate, too positive
		unsigned_err_STIM = 16'h0400;
		signed_err_STIM = 16'h0200;
		signed_D_diff_STIM = 10'h0040;
		#5
		$stop();
		
		// signed_err should saturate, too negative.
		// signed_D diff should saturate, too negative
		signed_err_STIM = 16'hFC00; // bit 9 is a 0
		signed_D_diff_STIM = 10'h380; // bit 7 is a 0
		#5
		$stop();
		
		
		// signed_err should not saturate. 
		// signed_D diff should not saturate_t
		signed_err_STIM = 16'hFF00; // bit 9 and 8 are 1
		signed_D_diff_STIM = 10'h3E0; // bit 7  and 6 are 1
		#5
		$stop();
	
	
	
	end
	
	
				  



endmodule
