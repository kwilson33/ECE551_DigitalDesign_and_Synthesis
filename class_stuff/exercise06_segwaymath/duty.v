module duty (mtr_duty, rev, ptch_err_I, ptch_err_sat, ptch_D_diff_sat);
//Kevin Wilson
	localparam MIN_DUTY = 10'h3D4;										// 980 in decimal
	
	output [11:0] mtr_duty; 											// unsigned duty cycle of PWM drive to motor. MIN_DUTY + ABS(ptch_P + ptch_D + ptch_I)
	output rev; // 1 => reverse, 0=> forward
	
	input signed [6:0] ptch_D_diff_sat; 								// derivative of error
	input signed [9:0] ptch_err_sat; 									// pitch error term, signed
	input signed [9:0] ptch_err_I; 										// integral of error term

	wire signed [11:0] ptch_D_term;
	wire signed [9:0] ptch_P_term;
	wire signed [8:0] ptch_I_term;
	wire signed [12:0] ptch_PID; 										// 13 bits to hold sum of 12 bit #, 10 bit #, and a 10 bit #
	wire [11:0] ptch_PID_abs ; 											// absolute value of the error
	
	assign ptch_D_term  = ptch_D_diff_sat * $signed(9);  				// 7 bits * 5 bits takes 12 bits, proportional
	
	assign ptch_P_term = (ptch_err_sat >>> 1) + (ptch_err_sat >>> 2); 	// (3/4) * ptch_err_sat, derivative
	
	assign ptch_I_term = ptch_err_I[9:1];  								// integral term, divide by 2 by taking out the LSB aka taking first 9 bits
	
	assign ptch_PID = ptch_P_term + ptch_I_term + ptch_D_term; 			// all error added together
	
	assign rev = ptch_PID[12]; 											// reverse if a 1, forward if 0
	
	assign ptch_PID_abs = (rev) ? -ptch_PID : ptch_PID; 					// unsigned absolute value
	
	assign mtr_duty = MIN_DUTY + ptch_PID_abs;							// 12 bit result, we don't care about edge case where ptch_PID is most negative, which would need 13 bits to represent
	

endmodule
