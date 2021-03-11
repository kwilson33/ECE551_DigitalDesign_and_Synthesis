//Kevin Wilson 10/17/18
module UART_tb();

	reg clk_IN, rst_n_IN; //clock and reset inputs to UART_tx and UART_rcv

	reg clr_rdy_IN; //clr_rdy signal for UART_rcv
	wire tx_done; // when UART_tx is done transceiving
	
	wire rdy_OUT; //high UART_rcv is going to start receiving
	reg trmt_IN; //when UART_tx is ready to transceive
	
	reg [7:0] tx_data_IN; //data to be transceived for UART_tx
	wire [7:0] rx_data_OUT; //received data for UART_rcv
	
	logic TX_RX; //TX output for UART_tx and RX input for UART_rcv
	
	
	//Instantiate DUTs
	UART_tx iDUT_tx	(.clk(clk_IN), .rst_n(rst_n_IN), 
					. trmt(trmt_IN), 
					.tx_data(tx_data_IN), 
					.TX(TX_RX), 
					.tx_done(tx_done_OUT));
				
	UART_rcv iDUT_rcv(.clk(clk_IN), .rst_n(rst_n_IN),
						.rdy(rdy_OUT),
						.rx_data(rx_data_OUT),
						.RX(TX_RX),
						.clr_rdy(clr_rdy_IN));
						
	
	
	initial begin
	
		clk_IN = 0; //set clock and reset to 0
		rst_n_IN = 0; 
		trmt_IN = 0; //default values
		clr_rdy_IN = 0;
		@(posedge clk_IN);
		@(negedge clk_IN); //wait a full clock cycle before deasserting reset
		rst_n_IN = 1;
		
		//TEST CASE 1//////////////////////////////////////////////////////////////////////////////
		//Test for general functionality of shifting tx_data into the UART_rcv 
		
		trmt_IN = 1; //initiate transmitting
		tx_data_IN = 8'h2A; 
		// trmt should only be high for 1 clock,
		// so same tx_data isn't being read in every time
		@(posedge clk_IN) trmt_IN = 0; 
		
		//if tx_done is high, then rdy should also be high 
		//and at this point rx_data should have received all of tx_data
		if (tx_done_OUT & ((!(rdy_OUT)) | (tx_data_IN != rx_data_OUT)))
		$display("ERROR! Done transceiving, so ready should be high (waiting for another byte) \n ",
"and rx_data should equal tx_data");

		else $display ("Value of 0x%h was sucessfully transmitted then received!", tx_data_IN);

		repeat (30000) @(posedge clk_IN); //10 bits to transmit, each takes 2604 clock cycles
		$stop();
		////////////////////////////////////////////////////////////////////////////////////////////
		
		
		//TEST CASE 2//////////////////////////////////////////////////////////////////////////////
		//Test for functionality of clr_done signal
		rst_n_IN = 0;
		@(posedge clk_IN);
		@(negedge clk_IN); 
		rst_n_IN = 1;
		trmt_IN = 0; //no transmitting so rdy signal is high
		clr_rdy_IN = 1; //assert clr_rdy and check value of rdy
		if (rdy_OUT != 0) $display("ERROR! rdy should be deasserted!!");
		else $display ("clr_rdy works!!!! :)");
		repeat (15000) @(posedge clk_IN);
		$stop();
		clr_rdy_IN = 0; //deassert clr_rdy
		////////////////////////////////////////////////////////////////////////////////////////////
		
		
		//TEST CASE 3//////////////////////////////////////////////////////////////////////////////
		//One more test for general functionality of shifting tx_data into the UART_rcv 
		rst_n_IN = 0;
		@(posedge clk_IN);
		@(negedge clk_IN); 
		rst_n_IN = 1;
		trmt_IN = 1; //initiate transmitting
		tx_data_IN = 8'h96; // lots of alternating bits
		// trmt should only be high for 1 clock,
		// so same tx_data isn't being read in every time
		@(posedge clk_IN) trmt_IN = 0; 
		
		//if tx_done is high, then rdy should also be high 
		//and at this point rx_data should have received all of tx_data
		if (tx_done_OUT & ((!rdy_OUT ) | (tx_data_IN != rx_data_OUT)))
		$display("ERROR! Done transceiving, so ready should be high (waiting for another byte) \n",
"and rx_data should equal tx_data. Time = %t", $time);

		else $display ("Value of 0x%h was sucessfully transmitted then received!", tx_data_IN);

		repeat (30000) @(posedge clk_IN); 
		$stop();
		////////////////////////////////////////////////////////////////////////////////////////////
		
	end
	
	
	
	always begin
		#5 clk_IN = ~clk_IN;
	end
	
endmodule