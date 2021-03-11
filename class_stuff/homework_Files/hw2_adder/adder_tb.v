module adder_tb();
// Kevin Wilson
// 10/01/2018
	// inputs are 1 bit wider than the actual signals to allow for exhaustive loop testing
	reg  [4:0] A_STIM, B_STIM; 	
	reg  [1:0] cin_STIM;
	wire [3:0] Sum_OUT;
	wire co_OUT;
	reg  [4:0] tempSum; // use this for autochecking the DUT
	
	// Instantiate DUT //
	adder iDUT(.co(co_OUT), .Sum(Sum_OUT), .A(A_STIM[3:0]), .B(B_STIM[3:0]), .cin(cin_STIM[0]));
	
	initial begin
		$monitor("At = %t: A=%h, B=%h, cin=%b --> SUM=%h, cout=%b", $time, A_STIM[3:0], 
				B_STIM[3:0], cin_STIM, Sum_OUT, co_OUT);
			
		for (A_STIM = 0; A_STIM < 16; A_STIM = A_STIM + 1) begin
			for (B_STIM =0; B_STIM < 16; B_STIM = B_STIM + 1) begin
				for (cin_STIM = 0; cin_STIM < 2; cin_STIM = cin_STIM + 1)  begin
					/* use nonblocking to make sure 
					   that tempSum adds up the CURRENT values and not prev values
					   *****
					*/
					tempSum <= A_STIM + B_STIM + cin_STIM; 
															
					if ( (tempSum[4] != co_OUT) || (tempSum[3:0] != Sum_OUT) ) begin
						$display("MATH ADDING ERROR!");
						$stop();
					end
				#5; //wait for 5s and do loop again
				end
			end
		end
		$display("NO ISSUES!");
		$stop();
	end
endmodule
