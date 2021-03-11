module adder(Sum,co,A,B,cin);
// Kevin Wilson
// 10/01/2018
	output [3:0] Sum; 	// Sum
	output co; 		 	//carry out
	input [3:0] A,B; 	// operands
	input cin; 	 		// carry in and carry out
	
	
	assign {co, Sum} = A + B + cin;
endmodule
