// Kevin Wilson 11/4/18
`timescale 1ns/1ps 					//good practice to add this compiler directive
module SPI_mstr16_tb();
   

   //input to SPI Master and A/D SPI
   reg clk, rst_n;
   reg wrt;
   reg [15:0] cmd;

	//Output from SPI master
   wire done;							
   wire [15:0] rd_data;

	//Input/Output for both SPIs
   logic MISO;							// Input to SPI master an output from A/D SPI
   logic MOSI; 							// Output from SPI master and an input to A/D SPI
   logic SS_n, SCLK; 					// Output from master SPI, input to A/D SPI

	
	integer err_count;                          // count how many errors


	// Instantiate SPI_mstr_16 and SPI_ADC128S DUTs.
	// The master SPI will drive the SPI interface instantiated in ADC128.sv


	//MOSI, SS_n,  and SCLK are outputs from the master SPI
	SPI_mstr16 masterSPI (.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .SCLK(SCLK), .
								MOSI(MOSI), .MISO(MISO),
								.wrt(wrt), .cmd(cmd), 
								.done(done), .rd_data(rd_data));


	// SCLK, SS_n, and MOSI are inputs from the master SPI
	// This A/D converter instanitates a SPI using SPI_ADC128
	ADC128S drivenSPI (.clk(clk), .rst_n(rst_n), .SS_n(SS_n), 
							.SCLK(SCLK), .MOSI(MOSI), .MISO(MISO)); 
	
	
	/*
	 to read a channel from the ADC128S we send cmd = {2'b00, chnl[2:0], 11'h000}
	 where the only valid channels are 0,4,5 (3'b000, 3'b100, and 3'b101)
	
	 For the first two reads, response is 0xC00 + chnl. Decrements by 0x10 for every two reads
	 So expected values are :
	 Channel Read: 5, expected response = 0xC00 (requesting channel 5 for next time, returns channel 0 as first read)
	 Channel Read: 5, expected response = 0xC05 (hasn't decremented by 0x10 yet, channel 5 from last request)
	 Channel Read: 4, expected response = 0xBF5 (two reads performed, so decremented by 0x10 [(0xC00 - 0x10) + 0x5 = 0xBF5] still channel 5)
	 Channel Read: 4, expected respomse = 0xBF4 (channel 4 from last request, [(0xC00 - 0x1) + 0x4 = 0xBF4])
	*/
   initial begin
		err_count = 0;
		clk = 0;
		rst_n = 0; // start with reset asserted
		wrt = 0;
		@(posedge clk)
		@(negedge clk)
		rst_n = 1; // deassert reset on falling edge of clock
		
		//###################################################################### First test on Channel 0 ################################################################################
		wrt = 1;
		cmd = {2'b00, 3'b101, 11'h000}; //assumes reading from channel 0 since just now telling what channel we want, doesn't know we want channel 5 yet
		//wrt should be high for only one clock period to initiate transaction
		@(posedge clk) wrt = 0;
		
		//Use fork/join  to make sure done is asserted before checking value of rd_data
		
		fork
			begin: timeout1
				repeat (1000) @(posedge clk); //if done hasn't been asserted after 1000 clocks something is wrong
				$display("ERROR! Done failed to be asserted causing a timeout :(");
				err_count = err_count + 1;
				$stop();
			end

			begin
				@(posedge done)
				disable timeout1;
			end

		join

	
		
		//if done is high, then test value of rd_data
		if (rd_data != 16'hC00) begin
			$display("ERROR at time = %t ! Expected rd_data to be 0xC00, instead it was 0x%h.", $time, rd_data);
			err_count = err_count + 1;
			$stop();
		end	
		
	
		@(posedge clk);
		//#################################################################################################################################################################################




		//###################################################################### Second test on Channel 5 ################################################################################
		wrt = 1;
		cmd = {2'b00, 3'b101, 11'h000}; // reading from channel 5 from last request
		//wrt should be high for only one clock period to initiate transaction
		@(posedge clk) wrt = 0;
		
		fork
			begin: timeout2
				repeat (1000) @(posedge clk);
				$display("ERROR! Done failed to be asserted causing a timeout :(");
				err_count = err_count + 1;
				$stop();
			end

			begin
				@(posedge done)
				disable timeout2;
			end

		join

	
		
		//if done is high, then test value of rd_data
		if (rd_data != 16'hC05) begin
			$display("ERROR at time = %t ! Expected rd_data to be 0xC05, instead it was 0x%h.", $time, rd_data);
			err_count = err_count + 1;
			$stop();
		end	
		
	
		@(posedge clk);
		//#################################################################################################################################################################################



		//###################################################################### Third test on Channel 5 ################################################################################
		wrt = 1;
		cmd = {2'b00, 3'b100, 11'h000}; //	reading channel 5 from last request
		//wrt should be high for only one clock period to initiate transaction
		@(posedge clk) wrt = 0;
		
		fork
			begin: timeout3
				repeat (1000) @(posedge clk); 
				$display("ERROR! Done failed to be asserted causing a timeout :(");
				err_count = err_count + 1;
				$stop();
			end

			begin
				@(posedge done)
				disable timeout3;
			end

		join

	
		
		//if done is high, then test value of rd_data
		if (rd_data != 16'hBF5) begin
			$display("ERROR at time = %t ! Expected rd_data to be 0xBF5, instead it was 0x%h.", $time, rd_data);
			err_count = err_count + 1;
			$stop();
		end	
		
	
		@(posedge clk);
		//#################################################################################################################################################################################
		


		//###################################################################### Fourth test on Channel 4 ################################################################################
		wrt = 1;
		cmd = {2'b00, 3'b100, 11'h000}; // reading channel 4 from last request //TODO: do we need this?
		//wrt should be high for only one clock period to initiate transaction
		@(posedge clk) wrt = 0;
		
		fork
			begin: timeout4
				repeat (1000) @(posedge clk); 
				$display("ERROR! Done failed to be asserted causing a timeout :(");
				err_count = err_count + 1;
				$stop();
			end

			begin
				@(posedge done)
				disable timeout4;
			end

		join

	
		
		//if done is high, then test value of rd_data
		if (rd_data != 16'hBF4) begin
			$display("ERROR at time = %t ! Expected rd_data to be 0xBF4, instead it was 0x%h.", $time, rd_data);
			err_count = err_count + 1;
			$stop();
		end	
		//################################################################################################################################################################################
		if (err_count == 0) $display ("Testbench passed with no errors!! Congrats :)");
		else $display ("Still some work to do. Testbench ran with %d errors.", err_count);
		$stop();
	end
   
   

	always #2 clk = ~clk;		//2 ns clock for 500MHz frequency
	

endmodule
