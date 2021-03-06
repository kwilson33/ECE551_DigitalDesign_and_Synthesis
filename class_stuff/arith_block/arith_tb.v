module arith_tb();
//Kevin Wilson
// 9/21/18
	reg  [7:0]   stm_A,stm_B;  		// used as stimulus for A,B,
	reg 		 stm_SUB; 			// used as stimulus for SUB, determines if adding or subtracting
	wire [7:0]   SUM; 				// used to monitor SUM
	wire 		 OV; 				// used to monitor OV
	
	// Instantiate DUT //
	arith iDUT(.A(stm_A), .B(stm_B), .SUB(stm_SUB),
			   .SUM(SUM), .OV(OV));
	
	
	initial begin
	$monitor("At = %t: \n A=%h, B=%h, SUB=%d --> SUM=%d, OV=%b", $time, stm_A[7:0], 
			  stm_B[7:0], stm_SUB, SUM, OV);
	// A is neg, B is pos
	$display("A is -91, B is +90, result should be FF, or -1");
	stm_A = 8'hA5;
	stm_B = 8'h5A;
	stm_SUB = 0; // result should be FF
	#5; // wait 5 time units
	$stop();
	
	//A is neg, B is neg
	stm_SUB = 1; // should overflow
	$display("A is -91, B is -91, can't represent -182 with 7 bits, overflow");
	#5
	$stop();
	
	//A is pos, B is pos
	stm_SUB = 0;
	stm_A =   8'h5A;
	stm_B =   8'h5A;
	$display("A is +90, B is +90, can't represent 180 with 7 bits, overflow");
	#5
	$stop();
	
	//A is pos, B is neg
	stm_SUB = 1;
	$display("A is +90, B is -90, result should be 0");
	#5
	$stop();

	//A is pos, B is neg
	stm_B = 8'h80;
	stm_A = 8'h01;
	$display("A is +1, B is -128, result should be -127, no overflow");
	#5
	stm_SUB = 1;

	//A is pos, B is pos
	stm_B = 8'h7F;
	stm_A = 8'h7F;
	stm_SUB = 0;
	$display("A is +127, B is +127, result should be overflow");
	#5
	$stop();

	//A is neg, B is neg
	stm_B = 8'h7F;
	stm_A = 8'h80;
	stm_SUB = 1;
	$display("A is -128, B is -128, result should be overflow");
	#5
	$stop();

	//A is pos, B is neg
	stm_B = 8'h02;
	stm_A = 8'h01;
	$display("A is +1, B is -2, result should be -1 or FF");
	$stop();
	
	end
endmodule