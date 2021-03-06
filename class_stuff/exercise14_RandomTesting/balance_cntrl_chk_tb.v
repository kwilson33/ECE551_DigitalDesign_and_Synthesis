//Kevin Wilson, Shaoheng Zhou
module balance_cntrl_chk_tb();

reg clk, rst_n;
reg vld_sel,vld_tggle;
reg en_steer;
reg rider_off;
reg [15:0] ptch;
reg [11:0] ld_cell_diff;
reg [10:0] ans;


reg [23:0] response[0:999]; // 1000 vectors of response, 24 bits each
reg [31:0] stim[0:999]; //1000 vectors of stimulus, 32 bits each
reg [31:0] cur_stim; //assign entry of the stimulus vector to cur_stim in the for loop

reg [23:0] golden_response; //what we expect output to be
wire [23:0] cur_response; //what output actually is


///////////////////////////////////////
// Declare wires for outputs of DUT //
/////////////////////////////////////
wire [10:0] lft_spd,rght_spd;
wire lft_rev, rght_rev;
wire vld;
integer i;

  localparam P_COEFF = 5'h0E;
  localparam D_COEFF = 6'h14;				// D coefficient in PID control = +20 
    
  localparam LOW_TORQUE_BAND = 8'h46;	// LOW_TORQUE_BAND = 5*P_COEFF
  localparam GAIN_MULTIPLIER = 6'h0F;	// GAIN_MULTIPLIER = 1 + (MIN_DUTY/LOW_TORQUE_BAND)
  localparam MIN_DUTY = 15'h03D4;		// minimum duty cycle (stiffen motor and get it ready)
  

//////////////////////
// Instantiate DUT //
////////////////////
balance_cntrl iDUT(.clk(clk),.rst_n(cur_stim[31]),.vld(cur_stim[30]),.ptch(cur_stim[29:14]),.ld_cell_diff(cur_stim[13:2]), .lft_spd(cur_response[22:12]),.lft_rev(cur_response[23]),.rght_spd(cur_response[10:0]),.rght_rev(cur_response[11]),.rider_off(cur_stim[1]),.en_steer(cur_stim[0]));




initial begin
    //Read stim & response files into memory
	$readmemh("balance_cntrl_resp.hex", response);
	$readmemh("balance_cntrl_stim.hex", stim);
	clk = 0;
	#1; //wait 1 time unit to make sure everything is read in from files
	for ( i = 0; i < 1000; i = i + 1) begin
		cur_stim = stim [i];
		golden_response = response[i];
		@(posedge clk);
		#1; //wait another unit
		if (golden_response != cur_response) begin
			$display("Error at i = %d, time = %t\n Expected response to be %h but instead it was %h.", i, $time, golden_response, cur_response); 
			$stop();
		end
	end
	$display("SUCCESS!");
end
	
always
  #5 clk = ~clk;
  
endmodule
