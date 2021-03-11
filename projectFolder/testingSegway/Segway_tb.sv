module Segway_tb();


localparam MIN_RIDER_WEIGHT = 12'h200;
localparam BATT_THRESHOLD = 12'h800;

//// Interconnects to DUT/support defined as type wire /////
wire SS_n,SCLK,MOSI,MISO,INT;				// to inertial sensor
wire A2D_SS_n,A2D_SCLK,A2D_MOSI,A2D_MISO;		// to A2D converter
wire RX_TX;
logic PWM_rev_rght, PWM_frwrd_rght, PWM_rev_lft, PWM_frwrd_lft;

wire piezo,piezo_n;

////// Stimulus is declared as type reg ///////
reg clk, RST_n;
reg [7:0] cmd;					// command host is sending to DUT
reg send_cmd;					// asserted to initiate sending of command
reg signed [15:0] rider_lean;			


/////// declare any internal signals needed at this level //////
wire cmd_sent;
logic [11:0] lft_ld, rght_ld, batt;					// forward/backward lean (goes to SegwayModel)
logic [15:0] ptch;
logic rst_n;
// Perhaps more needed?


////////////////////////////////////////////////////////////////
// Instantiate Physical Model of Segway with Inertial sensor //
//////////////////////////////////////////////////////////////	
SegwayModel iPHYS(.clk(clk),.RST_n(RST_n),.SS_n(SS_n),.SCLK(SCLK),
                  .MISO(MISO),.MOSI(MOSI),.INT(INT),.PWM_rev_rght(PWM_rev_rght),
				  .PWM_frwrd_rght(PWM_frwrd_rght),.PWM_rev_lft(PWM_rev_lft),
				  .PWM_frwrd_lft(PWM_frwrd_lft),.rider_lean(rider_lean));				  

/////////////////////////////////////////////////////////
// Instantiate Model of A2D for load cell and battery //with
///////////////////////////////////////////////////////
ADC128S drivenSPI (.clk(clk), .rst_n(RST_n), .SS_n(SS_n), 
							.SCLK(SCLK), .MOSI(MOSI), .MISO(MISO),
							.lft_ld(lft_ld), .rght_ld(rght_ld), .batt(batt)); 
  
////// Instantiate DUT ////////
Segway iDUT(.clk(clk),.RST_n(RST_n),.LED(),.INERT_SS_n(SS_n),.INERT_MOSI(MOSI),
            .INERT_SCLK(SCLK),.INERT_MISO(MISO),.A2D_SS_n(A2D_SS_n),
			.A2D_MOSI(A2D_MOSI),.A2D_SCLK(A2D_SCLK),.A2D_MISO(A2D_MISO),
			.INT(INT),.PWM_rev_rght(PWM_rev_rght),.PWM_frwrd_rght(PWM_frwrd_rght),
			.PWM_rev_lft(PWM_rev_lft),.PWM_frwrd_lft(PWM_frwrd_lft),
			.piezo_n(piezo_n),.piezo(piezo),.RX(RX_TX));

//// Instantiate UART_tx (mimics command from BLE module) //////
//// You need something to send the 'g' for go ////////////////
//Probably just the AUTH_blk
UART_tx iTX(.clk(clk),.rst_n(RST_n),.TX(RX_TX),.trmt(send_cmd),.tx_data(cmd),.tx_done(cmd_sent));


initial begin  
  Initialize;   
  test1;
	
  $display("YAHOO! test passed!");
  
  $stop();
end

always
  #10 clk = ~clk;


`include "tb_tasks.sv"	
`include "tb_tests.sv"	

endmodule	
