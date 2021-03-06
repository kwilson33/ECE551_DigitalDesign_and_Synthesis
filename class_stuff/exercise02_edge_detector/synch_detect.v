module synch_detect (fall_edge, clk, asynch_sig_in);
// Kevin Wilson
// 9/14/18

/*
// asynch_sig_in => input to synchronize and detect falling edge on
// fall_edge => output of your block that is high for 1 clock cycle after falling edge occurs on asynch_sig_in
*/
output fall_edge;
input clk, asynch_sig_in;

wire asynch_sig_in_FF1, asynch_sig_in_FF2, asynch_sig_in_FF3;
 
 
//asynch_sig_in is double flopped for meta-stability reasons prior to use
dff flop1(
	.D (asynch_sig_in),
	.clk (clk),
	.Q (asynch_sig_in_FF1)
);


dff flop2(
	.D (asynch_sig_in_FF1),
	.clk (clk),
	.Q (asynch_sig_in_FF2)
);

//flop again for use in edge_detect
dff flop3(
	.D (asynch_sig_in_FF2),
	.clk (clk),
	.Q (asynch_sig_in_FF3)
);
	

and edge_detect(fall_edge, !asynch_sig_in_FF2, asynch_sig_in_FF3);

endmodule

