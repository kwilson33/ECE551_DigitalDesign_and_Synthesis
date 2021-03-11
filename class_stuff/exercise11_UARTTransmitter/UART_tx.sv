// Kevin Wilson 10/13/18
module UART_tx (TX, tx_done, clk, rst_n, trmt, tx_data);

	input clk, rst_n; //50MHz system clock, active low reset
	input logic trmt; // initiates transmission
	input logic [7:0] tx_data; //byte to trasnmit
	output logic TX, tx_done; //TX is serial data output, tx_done is asseered when done transmitting, stays high until next byte transmitted
	
	logic set_done, clr_done; //comes out of SM into FF to determine if done transmitting
	
	reg [11:0] baud_cnt; //12 bit count
	reg [3:0] bit_cnt; //4 bit count
	reg [8:0] tx_shft_reg;
	logic load, shift, transmitting; // determines what the counters and FFs do


	typedef enum reg {IDLE, TRANSMITTING} state_t;
	state_t state, nxt_state;
	
	//continously updating
	assign shift = (baud_cnt >= 12'd2604); //shift is high if it greater or equal to 2604
	assign TX = tx_shft_reg[0]; //1st bit of tx_shft_reg is the serial data output
	
	
	// sequential logic for SM state register
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) state <= IDLE;
		else state <= nxt_state;
	end
	
	// state transition and output logic
	always_comb begin //inputs are shift, bit_cnt
		set_done = 0;
		load = 0; //can use load as your clr_done signal
		transmitting = 0;
		
		case (state)
			IDLE: begin
				//check if you should start transmitting
				if (trmt) begin // asserted for 1 clock to initiate transmission
					nxt_state = TRANSMITTING;
					load = 1; //same thing as your clr_done signal
				end
			end
				
			
			default: begin
				// check if you've transmitted all 10 bits
				// if so go back to IDLE and set set_done = 1;
				if (bit_cnt == 4'hA) begin //check if bit_cnt has reached reached 10, signaling that done transmititng 
					nxt_state = IDLE;
					set_done = 1; 
				end
				
				// keep transmitting 
				else begin
					nxt_state = TRANSMITTING;
					transmitting = 1;
				end
			end
			
		endcase
		
		
	end
	
	//SR flop
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n)
			tx_done <= 0;
		else if (clr_done) //Use clr_done as your load signal
			tx_done <= 1'b0;
		else if  (set_done)
			tx_done <=1'b1;
	end
			
	
	// count how many bits are transmitted
	always_ff @(posedge clk) begin
		casex ({load,shift})
		
			//reset counter if LOAD
			2'b1x: 
				bit_cnt <= 4'h0;
			
			//add 1
			2'b01: 
				bit_cnt <= bit_cnt + 1;
			
			//maintain value 
			default : bit_cnt <= bit_cnt;
			
		endcase
	end
	
	
	//waits to see when you should start shifting by counting up, then asserts shift 
	always_ff @(posedge clk) begin
		casex ({(load|shift), transmitting})
		
			//reset counter if LOAD or SHIFT
			2'b1x:
				baud_cnt <= 12'h000;
			
			//add 1 if TRANSMITTING
			2'b01:
				baud_cnt <= baud_cnt + 1;
				
			//maintain value
			default: baud_cnt <= baud_cnt;
			
		endcase
	end
	
	//align to UART transmitting format, appends stop bit, serial transmit
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) //active low preset
			tx_shft_reg <= 9'h1FF; 
		else begin
			casex ({load,shift})
			
				//LOADS {tx_data, 1'b0}
				2'b1x:
					tx_shft_reg <= {tx_data, 1'b0};
				//SHIFT in a 1 from the left
				2'b01: 
					tx_shft_reg <= {1'b1, tx_shft_reg[8:1]};
				//maintain value
				default: tx_shft_reg <= tx_shft_reg;
				
			endcase
		end
	end
	

endmodule
