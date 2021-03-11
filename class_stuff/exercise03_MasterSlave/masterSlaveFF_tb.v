module masterSlaveFF_tb();
//Kevin Wilson
reg clk, d;

wire q;

//Instantiate DUT//
masterSlaveFF iDUT(.clk(clk), .d(d), .q(q));


initial begin
	clk = 0;
	d = 0;
	repeat(2) @(posedge clk); // wait for clock to rise twice before executing commands below
	d = 1;
	@(posedge clk);
	d = 0; 
	@(posedge clk);
	$stop();
end
//every 10ns the clock becomes high and output changes 
always	
	#5 clk=~clk;
	
endmodule;

