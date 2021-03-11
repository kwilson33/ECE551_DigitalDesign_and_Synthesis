// Kevin Wilson
// 10/15/18
module mtr_drv_tb();

reg clk_IN, rst_n_IN, lft_rev_IN, rght_rev_IN;
reg [10:0] rght_spd_IN, lft_spd_IN;

wire PWM_rev_lft_OUT, PWM_frwrd_lft_OUT, PWM_rev_rght_OUT, PWM_frwrd_rght_OUT;	

// Instantiate DUT
mtr_drv iDUT ( .clk(clk_IN), .rst_n(rst_n_IN), .lft_spd(lft_spd_IN), .rght_spd(rght_spd_IN),
			   .lft_rev(lft_rev_IN), .rght_rev(rght_rev_IN), .PWM_rev_lft(PWM_rev_lft_OUT),
			   .PWM_frwrd_lft(PWM_frwrd_lft_OUT), .PWM_rev_rght(PWM_rev_rght_OUT), .PWM_frwrd_rght(PWM_frwrd_rght_OUT));
			   
initial begin
	clk_IN = 0; // set clock to 0 and assert reset
	rst_n_IN = 0;
	@(posedge clk_IN); // wait a full clock cycle to deassert reset
	@(negedge clk_IN);
	rst_n_IN = 1;
	
	//start at max speed, left driving forward, right driving reverse
	lft_spd_IN = 11'h07FF;
	rght_spd_IN = 11'h07FF;
	
	rght_rev_IN = 1;
	lft_rev_IN = 0;
	repeat (6000) @(posedge clk_IN);
	repeat (6000) @(posedge clk_IN);
	
	//tranisition to half speed
	lft_spd_IN = 11'h0400;
	rght_spd_IN = 11'h0400;
	repeat (6000) @(posedge clk_IN);
	
	//tranisition to min speed
	lft_spd_IN = 11'h0001;
	rght_spd_IN = 11'h0001;
	repeat (6000) @(posedge clk_IN);
	
	//tranisition to no speed
	lft_spd_IN = 11'h0;
	rght_spd_IN = 11'h0;
	repeat (6000) @(posedge clk_IN);
	
	//change directions for both motors
	rght_rev_IN = 0;
	lft_rev_IN = 1;
	
	//increase up speed to min speed
	lft_spd_IN = 11'h0001;
	rght_spd_IN = 11'h0001;
	repeat (6000) @(posedge clk_IN);
	
	
	//ramp up speed to half speed
	lft_spd_IN = 11'h0400;
	rght_spd_IN = 11'h0400;
	repeat (6000) @(posedge clk_IN);
	
	
	//go all the way to max speed
	lft_spd_IN = 11'h07FF;
	rght_spd_IN = 11'h07FF;
	repeat (6000) @(posedge clk_IN);
	$stop();
end


always begin
	#5 clk_IN = ~clk_IN;
end
endmodule
