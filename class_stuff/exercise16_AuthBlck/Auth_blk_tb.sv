//Kevin Wilson 11/6/18
module Auth_blk_tb();
	// In this testbench, using UART transeiver to send signal to UART receiver (inside Auth_blk) 
	// and test how the state machin in Auth_blk.sv responds to different inputs
	
	localparam go = 8'h67; 		// signal from Bluetooth telling to power up. 
	localparam stop = 8'h73; 	// signal from Bluetooth telling to stop. 
	
	
	//Signals for both UART_tx and Auth_blk
	logic TX_RX; 				// TX output for UART_tx and RX input for UART_rcv
	reg clk, rst_n; 			//clock and reset inputs to UART_tx and Auth_blk 
	
	// Signals for transceiver
	reg trmt; 					// when UART_tx is ready to transceiver
	wire tx_done; 				// when UART_tx is done transceiving
	reg [7:0] tx_data; 			//data to be the transeiver is sending to Auth_blk

	// Signals for Auth_blk
	wire pwr_up;
	reg rider_off;
	
	
	// Instantiate UART transeiver to send inout to the Auth_blk
	UART_tx transeiver (.clk(clk), .rst_n(rst_n), . trmt(trmt), 
					.tx_data(tx_data), .TX(TX_RX), .tx_done(tx_done));
	
	// Instantiate DUT of Auth_blk to be tested
	Auth_blk iDUT(.clk(clk), .rst_n(rst_n), .rider_off(rider_off), .pwr_up(pwr_up), .RX(TX_RX));
	
	
	initial begin		
		clk = 0;									// assert reset and set default values
		rst_n = 0;
		trmt = 0;
		rider_off = 0;
		@(posedge clk)
		@(negedge clk)
		rst_n = 1;									// deassert reset
		
		
		
		// ##################### TEST CASE 1: OFF -> PWR1 ###########################################
		tx_data = go;								// test going from OFF state to PWR1
		trmt = 1; @(posedge clk) trmt = 0;			// initiate transmitting and deassert after one clock
	
		repeat (30000) @(posedge clk); 	// 10 bits to transmit, each takes 2604 cycles
		if (iDUT.state != Auth_blk_tb.iDUT.PWR1) begin
			$display("ERROR! Received go signal, should be in PWR1 state.");
			$stop;
		end
		else begin
			$display("Passed first test!");
		end
		// ##############################################################################
		
		
		
		// ##################### TEST CASE 2 : OFF -> PWR1 - > OFF ###########################################
		tx_data = go;								
		trmt = 1; @(posedge clk) trmt = 0;			
					
		repeat (30000) @(posedge clk);				// wait for go data to be totally received before sending in new data
		rider_off = 1;								// if rider is off, go back to OFF state
		tx_data = stop;								// Send stop signal
		trmt = 1; @(posedge clk) trmt = 0;
	
		repeat (30000) @(posedge clk); 	
		if (iDUT.state != Auth_blk_tb.iDUT.OFF) begin
			$display("ERROR! Received stop signal and rider is off, should be in OFF state.");
			$stop;
		end
		else begin
			$display("Passed second test!");
		end
		// ##############################################################################
		
		
		// ##################### TEST CASE 3 : OFF -> PWR1 - > PWR2 ###########################################
		trmt = 1; 		
		rider_off = 0;
		tx_data = go;								// go to PWR1
		@(posedge clk) trmt = 0;			
		
		repeat (30000) @(posedge clk);				//wait for go data to be totally received before sending in new data
		tx_data = stop;								// Send stop signal, go to PWR2
		
		trmt = 1; @(posedge clk) trmt = 0;
	
		repeat (30000) @(posedge clk); 	
		if (iDUT.state != Auth_blk_tb.iDUT.PWR2) begin
			$display("ERROR! Received stop signal and rider is on, should be in PWR2 state.");
			$stop;
		end
		else begin
			$display("Passed third test!");
		end
		// ##############################################################################
		
		
		
		
		
		$stop;
	end
	
	
	
	always #5 clk = ~clk;



endmodule
