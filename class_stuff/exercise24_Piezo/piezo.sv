module piezo(clk, rst_n, norm_mode, ovr_spd, batt_low, piezo, piezo_n);

	//These values we're determined by calulating how many clock
	//periods from the global 50MHz clock we'd need to wait in order
	//to get our desired frequencies (i.e. for the first value the calulation was:
	// (1/2kHz)(1/50MHz) = 25,000, and then we need to divide that by two because we
	//need to know when to toggle the output wave in order for it to be...well...a wave)
	localparam NORM_CNT_FULL = 16'h30D4;	// need to wait 12,500 clocks to generate 2kHz sig
	localparam OVR_CNT_FULL = 16'h1388;	// need to wait 5,000 clocks to generate 5kHz sig
	localparam BATT_CNT_FULL = 16'h186A;	// need to wait 6,250 clocks to generate 4kHz sig
	localparam NORM_PERIOD = 28'h2FAF080;	// controls period of signal when in normal mode (covers 1 second)
	localparam NORM_DUTY = 28'h0BEBC20;	// duty cycle of buzzer when in normal mode (1/4 second)


	input clk, rst_n;			// 50 Mhz clock
	input norm_mode;			// tone should occur at least once every 2 seconds, not obnoxious
	input batt_low;				// should be alarming
	input ovr_spd;				// comes from balance_ctrl. Should be able to occur same time as batt_low sound

	output piezo,piezo_n;			//output to drive piezo and it's complement

	reg [13:0] norm_mode_cnt;		//counter for controlling period of 2kHz digital square wvae
	reg [12:0] ovr_spd_cnt;			//counter for controlling period of 5kHz digital square wave
	reg [12:0] batt_low_cnt;		//counter for controlling period of 4kHz digital square wave
	reg [27:0] norm_freq_cnt;		//counter for controlling frequency with which buzzer sounds in normal mode
	logic norm_cnt_full,ovr_cnt_full,batt_cnt_full;	//is true when each signal's respective counter is equal
							//to it's respective local parameter that was designated in order
							//to achieve some desired frequency
	logic norm_mode_wave,ovr_spd_wave,batt_low_wave;//wave generated by checking when each signal's respective counter
							//is full and then we toggle the wave signal
	logic en_norm;	//PWM output that confines normal mode buzzer to sound out for 

	PWM28	iPWM(.clk(clk),.rst_n(rst_n),.duty(NORM_DUTY),.period(NORM_PERIOD),.PWM_sig(en_norm));

	//Each counter flip-flop for each input signal is essentially working in the
	//same way. There are 3 ways in which we're zeroing the counter:
	// 1) upon reset, 2) when not in that state (i.e. norm_mode is low, ovr_spd is low, etc.),
	// and 3) when the counter reaches it's max value which gives us a desired frequency as 
	//calculated previously. Otherwise we're just incrementing the counter as would be expected.
	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    norm_mode_cnt <= 0;
	  else if (!norm_mode)
	    norm_mode_cnt <= 0;
	  else if (norm_cnt_full)
	    norm_mode_cnt <= 0;
	  else
	    norm_mode_cnt <= norm_mode_cnt + 1;


	assign norm_cnt_full = (norm_mode_cnt == NORM_CNT_FULL);
	assign norm_mode_wave = norm_cnt_full ? ~norm_mode_wave : 
				norm_mode ? norm_mode_wave : 0;

	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    ovr_spd_cnt <= 0;
	  else if (!ovr_spd)
	    ovr_spd_cnt <= 0;
	  else if (ovr_cnt_full)
	    ovr_spd_cnt <= 0;
	  else
	    ovr_spd_cnt <= ovr_spd_cnt + 1;

	assign ovr_cnt_full = (ovr_spd_cnt == OVR_CNT_FULL);
	assign ovr_spd_wave = ovr_cnt_full ? ~ovr_spd_wave : 
			       ovr_spd ? ovr_spd_wave : 0;

	always_ff @(posedge clk, negedge rst_n)
	  if (!rst_n)
	    batt_low_cnt <= 0;
	  else if (!batt_low)
	    batt_low_cnt <= 0;
	  else if (batt_cnt_full)
	    batt_low_cnt <= 0;
	  else
	    batt_low_cnt <= batt_low_cnt + 1;

	assign batt_cnt_full = (batt_low_cnt == BATT_CNT_FULL);
	assign batt_low_wave = batt_cnt_full ? ~batt_low_wave :
				batt_low ? batt_low_wave : 0;

	//// Assigning piezo and it's complement ////
	assign piezo = ovr_spd	 ? ovr_spd_wave	  :
		       batt_low	 ? batt_low_wave  :
		       norm_mode ? (norm_mode_wave & en_norm):
		       0;
	assign piezo_n = ~piezo;


endmodule