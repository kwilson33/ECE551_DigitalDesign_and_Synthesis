module saturate(unsigned_err_sat, signed_D_diff_sat, signed_err_sat,
		unsigned_err, signed_err, signed_D_diff);
//Kevin Wilson

	localparam most_neg10b 			= 10'h200; 		// most negative value in 10 bits
	localparam greatest10b_signed	= 10'h1FF; 		// most positive value in 10 bits signed
	localparam greatest10b_unsigned	= 10'h3FF; 		// most positive value in 10 bits unsigned
	localparam greatest7b_signed    =  7'h3F;		// most positive value in 7 bits  signed
	localparam most_neg7b   		=  7'h40;		// most negative value in 7 bits



	output [9:0] unsigned_err_sat; 				// 10 bit saturated version of unsigned_err[15:0]
	output [6:0] signed_D_diff_sat; 			// 7 bit signed saturated version of signed_D_diff[9:0]
	
	/* 10 bit saturated version of signed_err[15:0]
	   If result is pos and greater than 0x1FF, then saturates to 0x1FF. If neg and
	   less than 0x200, saturate to 0x200
	*/ 
	output [9:0] signed_err_sat;
	
	input [15:0] unsigned_err;  				// 16 bit unsigned error term to be reduced/saturated to 10 bits
	input [15:0] signed_err;					// 16 bit signed number to be reduced/saturated to 10 bits
	input [9:0]  signed_D_diff;     			// 10 bit signed version of a difference term used for deriv calculation
	
	
	
	
	//first, reduce/saturate unsigned_err because it's always positive
	/* if any bits in range [15:10] are 1, 
	   then too big to represent with 10 bits
	   so just saturate to greatest10b_unsigned
	*/ 
	assign unsigned_err_sat = ( |unsigned_err[15:10] ) ? greatest10b_unsigned : unsigned_err[9:0]; 
	
	

	//next, reduce/saturate signed_err_sat
	assign signed_err_sat = (signed_err[15])    ? //check if positive or negative

				/* if negative, check bits [15:9] for any 0s, if not, keep [9:0], 
				   if any 0s then too negative  and saturate to most_neg10b.
				*/ 
				(&signed_err[15:9]  ? signed_err[9:0] : most_neg10b) : 

				/* if positive, check bits [15:9] for any 1s, if not, keep [9:0],
			           if any 1s, too positive and saturate to greatest10b_signed
				*/ 
				(|signed_err[15:9]) ? greatest10b_signed : signed_err[9:0];
	

	//finally, reduce/saturate signed_D_diff_sat;
	assign signed_D_diff_sat = (signed_D_diff[9]) ?
				   (&signed_D_diff[9:6] ? signed_D_diff[6:0] : most_neg7b) :
				   (|signed_D_diff[9:6])? greatest7b_signed : signed_D_diff[6:0];

endmodule




		