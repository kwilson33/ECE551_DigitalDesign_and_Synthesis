// Kevin Wilson 10/13/18
module UART_tx_tb();

	reg clk_IN, rst_n_IN, trmt_IN, tx_done_OUT, TX_OUT;
	reg [7:0] tx_data_IN; //byte that we're transmitting
	
	
	//Instantiate DUT
	UART_tx iDUT(.clk(clk_IN), .rst_n(rst_n_IN), . trmt(trmt_IN), 
				.tx_data(tx_data_IN), .TX(TX_OUT), .tx_done(tx_done_OUT));
	
	
	initial begin
		clk_IN = 0; //set clock and reset to 0
		rst_n_IN = 0; 
		@(posedge clk_IN);
		@(negedge clk_IN); //wait a full clock cycle before deasserting reset
		
		rst_n_IN = 1;
		trmt_IN = 1; //start transmitting
		tx_data_IN = 8'h2A; 
		repeat (30000) @(posedge clk_IN); //10 bits to transmit, each takes 2604 clock cycles
		$stop();
		
		rst_n_IN = 0;
		@(posedge clk_IN);
		@(negedge clk_IN); //wait a full clock cycle before deasserting reset
		rst_n_IN = 1;
		tx_data_IN = 8'hB3;
		repeat (30000) @(posedge clk_IN);
		$stop();
		
		rst_n_IN = 0;
		@(posedge clk_IN);
		@(negedge clk_IN); //wait a full clock cycle before deasserting reset
		rst_n_IN = 1;
		tx_data_IN = 8'hF1;
		repeat (30000) @(posedge clk_IN);
		$stop();
		
		
			
	end
	
	
	always begin
		#5 clk_IN = ~clk_IN;
	end
	
endmodule
		
	
	