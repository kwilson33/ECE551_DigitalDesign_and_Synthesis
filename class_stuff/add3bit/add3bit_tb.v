module add3bit_tb();
//Kevin Wilson

	//1 bit wider than A,B in add3bit module because we need to ensure
	//loop stops when it reaches value of 7. If only 3 bits, would get to 7
	//add 1, wrap around to 0 and continue forever
	reg  [3:0] A_stim,B_stim; 
	reg  [1:0] Cin_stim;
	wire [2:0] Sum;
	wire Cout;
	
	///////Instantiate DUT //////
	add3bit iDUT(.A(A_stim[2:0]), .B(B_stim[2:0]), .Cin(Cin_stim[0]), 
				 .Sum(Sum), .Cout(Cout));
	
	initial begin
	$monitor("At = %t: A=%h, B=%h, Cin=%b --> Sum=%h, Cout=%b", $time, A_stim[2:0], 
			  B_stim[2:0], Cin_stim[2:0], Sum, Cout);
			  
		for (A_stim = 0; A_stim < 8; A_stim = A_stim + 1)
			for (B_stim =0; B_stim < 8; B_stim = B_stim + 1)
				for (Cin_stim = 0; Cin_stim < 2; Cin_stim = Cin_stim + 1)
				#5;
	$stop();
	end
		
endmodule