module add3bit(A,B,Cin,Sum,Cout);
//Kevin Wilson

	input [2:0] A, B;
	input Cin;
	output [2:0] Sum;
	output Cout;

	assign {Cout,Sum} = A + B + Cin;

endmodule