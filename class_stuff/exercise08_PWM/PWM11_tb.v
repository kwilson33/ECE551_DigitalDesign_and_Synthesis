// 6000 - 10000 clocks for each test since 24.4 kHz
// test 3 different duty conditions	
module PWM11_tb();
// Kevin Wilson
// 10/05/18
	reg clk, rst_n;
	reg [10:0] duty_IN;
	
	wire PWM_sig_OUT;
	
	
	//Instantiate DUT//
	PWM11 iDUT(.PWM_sig(PWM_sig_OUT),.clk(clk), .rst_n(rst_n), .duty(duty_IN));
	
	always begin
		//set clk and rst to 0, wait for a full clock cycle before deasserting reset
		clk = 0;
		rst_n = 0;
		@(posedge clk);
		@(negedge clk);
		
		//min duty cycle, high for 1 out of 2048 cycles
		rst_n = 1; 						//deassert reset
		duty_IN = 11'h001; 	
		repeat (8192) @(posedge clk); 	//wait for 8192 clocks, essentially 4096 cycles.
		
		//mid duty cycle, 50% 
		duty_IN = 11'h0400; 	
		repeat (8192) @(posedge clk);
		
		//max duty, 99%
		duty_IN = 11'h07FF;
		repeat (8192) @(posedge clk);   	
		$stop();
	end
	
	always 
		#1 clk <= ~clk; //clock cycle is 1, so period is 2
		
endmodule
