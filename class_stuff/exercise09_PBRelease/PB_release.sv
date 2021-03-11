//push button to enable counting
//make up_dwn counter, based on dwn signal
//make rst_synch
module PB_release(released, clk, PB, rst_n);
	input clk, PB, rst_n;
	output released;
	reg pre1, pre2, pre3;
	

	always @(posedge clk, negedge rst_n) begin
		//asynch preset, set to 1
		if (!rst_n) begin
			pre1 <= 1;
			pre2 <= 1;
			pre3 <= 1;
		end
		
		else begin
			pre1 <= PB;
			pre2 <= pre1;
			pre3 <= pre2;
		end
	end
	
	//detects a rising edge
	assign released = ((~pre3) & pre2);  
	
endmodule
