
// Kevin Wilson
// 10/01/18

/*
The code below does not model a D latch correctly because it depends on the clock when it should depend on an enable
If clock changes, either posedge or negedge, the q will get re-evaluated. To fix this, edit the sensitivty list
to be @(clk,d) so if d changes when clk is high, q is re-evaluated
module latch(d,clk,q);

 	input d, clk;
	output reg q;
	always @(clk)
	if (clk)
		q <= d;
endmodule
*/

module active_high_synchReset_FF (Q,clk,D,rst);
	
	input D, clk, rst;
	output reg Q;

	always_ff @(posedge clk) begin // always_ff does NOT ensure the logic will infer a flip flop. however, synthesizer will warn you if the code does not. Basically an error handler
				       // if HW below is not sequential/FF logic and instead is combinational logic.

		if (rst)
			Q <= 1'b0;
		else
			Q <= D;

	end
endmodule


module active_low_asynchReset_FF (Q,clk,D,EN,rst_n);

	input D, clk, rst_n, EN;
	output reg Q;

	always_ff @(posedge clk, negedge rst_n) begin
		
		if(!rst_n)
			Q <= 1'b0;
		else if(EN)
			Q <= D;
		// don't need an else because will automatically retain old value if EN is not set. Only use an else if you are trying to make combinational logic.
		// In this case we are TRYING to make sequential logic, so inferring a latch is fine.
	end	
endmodule


module active_low_asynchReset_SR_FF (Q,clk,S,R,rst_n);
	
	input S, R, clk, rst_n; // R is active high synch reset, rst_n is active low asynch reset
	output reg Q;

	always_ff @(posedge clk, negedge rst_n) begin

		if (!rst_n) 	// active low asynch reset
			Q <= 1'b0;
		else if (R) 	// active high synch reset
			Q <= 1'b0;
		else if (S)    // if R is not high, set Q to value of S
			Q <= S;
			
		//Q retains value if S and R are not high

	end
endmodule
		