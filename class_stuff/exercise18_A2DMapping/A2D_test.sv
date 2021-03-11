module A2D_test(clk,RST_n,SEL,LED,SCLK,SS_n,MOSI,MISO);

  input clk,RST_n;	// clk and unsynched reset from PB
  input SEL;			// from 2nd PB, cycle through outputs
  input MISO;			// from A2D
  
  output [7:0] LED;
  output SS_n;			// active low slave select to A2D
  output SCLK;			// SCLK to A2D SPI
  output MOSI;
  
  ////////////////////////////////////////////////////////////
  // Declare any needed internal signals		   //
  //////////////////////////////////////////////////////////
  logic rst_n;
  logic [1:0]cntr;			//LED select counter
  logic [18:0]FR_cntr;		//free running counter to 
							//bring us to the next A2D
							//transaction
  logic nxt;
  logic en_2bit;
  logic [11:0]lft_ld,rght_ld,batt;

  //////////////////////////////////////////////////
  // Infer 19-bit counter to set conversion rate //
  ////////////////////////////////////////////////
  
  assign nxt = &FR_cntr;
  
  always_ff @(posedge clk,negedge rst_n) begin
    if (!rst_n)
      FR_cntr <= 0;
    else
      FR_cntr <= FR_cntr + 1;
	end

  
  
  ////////////////////////////////////////////////////////////////
  // Infer 2-bit counter to select which output to map to LEDs //
  //////////////////////////////////////////////////////////////
  always_ff @(posedge clk,negedge rst_n) begin
    if (!rst_n) begin
      cntr <= 0;
	 end
    else if (en_2bit) begin
      if(cntr == 2'b10)
        cntr <= 2'b00;
      else
        cntr <= cntr + 1;
	  end
	end
	  
  //////////////////////////////////////////////////////
  // Infer Mux to select which output to map to LEDs //
  //////////////////////////////////////////////////// 
  assign LED = (!cntr[1]) ? ( (!cntr[0]) ? lft_ld[11:4] : rght_ld[11:4]) :
			  batt[11:4];
	
  //////////////////////
  // Instantiate DUT //
  ////////////////////  
  A2D_intf iDUT(.clk(clk),.rst_n(rst_n),.nxt(nxt),.lft_ld(lft_ld),
                .rght_ld(rght_ld),.batt(batt),.SS_n_A2D(SS_n),.SCLK_A2D(SCLK),
				.MOSI_A2D(MOSI),.MISO_A2D(MISO));
			   
  ///////////////////////////////////////////////
  // Instantiate Push Button release detector //
  /////////////////////////////////////////////
  PB_release iPB(.clk(clk),.rst_n(rst_n),.PB(SEL),.released(en_2bit));
  
  /////////////////////////////////////
  // Instantiate reset synchronizer //
  ///////////////////////////////////
  rst_synch iRST(.clk(clk),.RST_n(RST_n),.rst_n(rst_n));   
	  
endmodule
  