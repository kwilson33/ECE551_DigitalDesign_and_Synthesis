// Kevin Wilson 10/13/18
module UART_rcv (RX, clr_rdy, clk, rst_n, rdy, rx_data);

	input clk, rst_n; //100MHz system clock, active low reset
	input logic RX, clr_rdy; //Serial data carrying command, clr_rdy is asserted to knock down the rdy signal
	output logic rdy; // asserted when a byte has been received. Falls when new start bit comes, or clr_rdy knocks it down
	output logic [7:0] rx_data; //the byte received, 8 bits
	
	
	logic set_rdy; //comes out of SM into FF to determine if ready to receive
	
	reg [11:0] baud_cnt; //12 bit count
	reg [3:0] bit_cnt; //4 bit count
	reg [8:0] rx_shft_reg; //9 bits
	reg metastabReg1RX, metastabReg2RX; // use for double flopping the RX
	logic start, shift, receiving; // determines what the counters and FFs do


	typedef enum reg {IDLE, RECEIVING} state_t;
	state_t state, nxt_state;
	
	//continuously assigned
	assign shift = (baud_cnt <= 12'h000); //wait until baud_cnt is equal to 0
	assign rx_data = rx_shft_reg[7:0]; //rx_data is first 8 bits of rx_shift reg, these are the bits received currently
	
	// sequential logic for SM state register
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n) state <= IDLE;
		else state <= nxt_state;
	end
	
	//FLOP LOGIC GOES HERE
	// state transition and output logic
	always_comb begin //inputs are shift, bit_cnt
		nxt_state = IDLE;
		set_rdy = 0;
		start = 0; 			//sets rdy to 0 when high
		receiving = 0; 
		
		case (state)
			IDLE: begin
				//check if you should start receiving. Checking for the start bit from the transceiver which is shifted in
				if (!metastabReg2RX) begin // if double flopped RX value is low, start receiving
					nxt_state = RECEIVING;
					start = 1; //sets rdy to 0 because new byte will begin being received
				end
			end
				
			
			default: begin
				// check if you've received all 10 bits
				// if so go back to IDLE and set set_rdy = 1;
				if (bit_cnt == 4'hA) begin //check if bit_cnt has reached reached 10, signaling that done receiving 
					nxt_state = IDLE;
					set_rdy = 1;  //rdy will stay high till start bit of next byte starts or until clr_rdy is asserted
				end
				
				// keep receiving 
				else begin
					nxt_state = RECEIVING;
					receiving = 1;
				end
			end
			
		endcase
		
		
	end

	
	// count how many bits are received
	always_ff @(posedge clk) begin
		casex ({start,shift})
		
			//reset counter if START
			2'b1x: 
				bit_cnt <= 4'h0;
			
			//add 1
			2'b01: 
				bit_cnt <= bit_cnt + 1;
			
			//maintain value 
			default : bit_cnt <= bit_cnt;
			
		endcase
	end
	
	//waits to see when you should start shifting by counting down, then asserts shift
	always_ff @(posedge clk) begin
		casex ({(start|shift), receiving})
			//load in 1/2 baud coun if START or full baud count if SHIFT
			2'b1x:
				if (start) //signifies the FIRST falling edge, start receiving
					baud_cnt <= 12'd1302; //load with half of the baud rate, //DO THIS SO ALL FUTURE VALUES WILL BE READ IN MIDDLE OF CLOCK 
				else 
					baud_cnt <= 12'd2604; //once you start shifting, use all of baud count
			//sub 1 if RECEIVING
			2'b01:
				baud_cnt <= baud_cnt - 1;
				
			//maintain value
			default: baud_cnt <= baud_cnt;
			
		endcase
	end
	
	
	
	//align to UART transmitting format, appends stop bit, serial transmit
	always_ff @(posedge clk, negedge rst_n) begin
			if (!rst_n) begin //Must preset 
				metastabReg1RX <= 1;
				metastabReg2RX <= 1;
			end
			metastabReg1RX <= RX; //metastability, double flop
			metastabReg2RX <= metastabReg1RX;
			case (shift)
				1'b1: 
					rx_shft_reg <= {metastabReg2RX, rx_shft_reg[8:1]}; //shift in RX into the MSB, shift LSB out
				//maintain value
				default: rx_shft_reg <= rx_shft_reg;
			endcase
	end
	
	
	//SR flop to determine if ready to receive
	always_ff @(posedge clk, negedge rst_n) begin
		if (!rst_n)
			rdy <= 0;
		else if  (clr_rdy | start) //ready falls if new start bit comes or clr_rdy is high
			rdy <= 1'b0;
		else if (set_rdy)
			rdy <= 1'b1;
	end
	
endmodule