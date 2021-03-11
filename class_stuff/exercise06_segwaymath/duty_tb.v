module duty_tb();
//Kevin Wilson
	reg signed [6:0] ptch_D_diff_sat_STIM; 
	reg signed [9:0] ptch_err_sat_STIM, ptch_err_I_STIM; 	
	
	//outputs
	wire rev_OUT;
	wire [11:0] mtr_duty_OUT;
	
	//Instantiate DUT//
	duty iDUT(.mtr_duty(mtr_duty_OUT), .rev(rev_OUT), .ptch_err_I(ptch_err_I_STIM), 
			.ptch_err_sat(ptch_err_sat_STIM), .ptch_D_diff_sat(ptch_D_diff_sat_STIM));

	initial begin
	$monitor("time = %t\nrev =%d,  mtr_duty=%d", 
			$time, rev_OUT, mtr_duty_OUT);
			  
			  
		$display("rev should be 0, mtr_duty should be 980");
		ptch_D_diff_sat_STIM = 0;
		ptch_err_sat_STIM = 0;
		ptch_err_I_STIM = 0;
		#5
		$stop();
		
		//4 cases for rev = 0
		
		$display("EXPECTING: ptch_D_term = 9, ptch_P_term = 6, ptch_I_term = 10\
ptch_PID = 25, rev = 0, ptch_PID_abs = 26, mtr_duty = 1005");
		ptch_D_diff_sat_STIM = 7'd1; // ptch_D_term should be 9
		ptch_err_sat_STIM = 10'd8;
		ptch_err_I_STIM = 10'd20;
		#5
		$stop();
		
		
		
		$display("EXPECTING: mtr_duty = 9 * (5) - 60 + 20 + 980 = 985");
		ptch_D_diff_sat_STIM = 7'd5; 
		ptch_err_sat_STIM = -10'd80;
		ptch_err_I_STIM = 10'd40;
		#5
		$stop();
		
		
		$display("EXPECTING: mtr_duty = 9 * (-5) + 60 + 10 + 980 = 1005");
		ptch_D_diff_sat_STIM = -7'd5;
		ptch_err_sat_STIM = 10'd80;
		ptch_err_I_STIM = 10'd20;
		#5
		$stop();
		
		$display("EXPECTING: mtr_duty = 9 * (5) + 60 -30 + 980 = 1055");
		ptch_D_diff_sat_STIM = 7'd5; 
		ptch_err_sat_STIM = 10'd80;
		ptch_err_I_STIM = -10'd60;
		#5
		$stop();
		
		//3 cases for rev = 1
		
		$display("EXPECTING: abs(mtr_duty = 9 * (-64) + 60 + 30)) = 486 + 980 = 1466");
		ptch_D_diff_sat_STIM = -7'd64;
		ptch_err_sat_STIM = 10'd80;
		ptch_err_I_STIM = 10'd60;
		#5
		$stop();
		
		$display("EXPECTING: abs(mtr_duty = 9 * (1) - 300 + 30 )) =  261 + 980) = 1241");
		ptch_D_diff_sat_STIM = 7'd1;
		ptch_err_sat_STIM = -10'd400;
		ptch_err_I_STIM = 10'd60;
		#5
		$stop();
		
		
		$display("EXPECTING: abs(mtr_duty = 9 * (1) + 30 - 200)) = 161 + 980) = 1141");
		ptch_D_diff_sat_STIM = 7'd1;
		ptch_err_sat_STIM = 10'd40;
		ptch_err_I_STIM = -10'd400;
		#5
		$stop();
		
		
	end
	
	

endmodule
