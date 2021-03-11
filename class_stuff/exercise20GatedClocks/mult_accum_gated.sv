//Kevin Wilson and Shaoheng Zhou
module mult_accum_gated(clk,clr,en,A,B,accum);

	input clk,clr,en;
	input [7:0] A,B;
	output reg [63:0] accum;

	reg [15:0] prod_reg;
	reg en_stg2;


	logic clk_en_lat, clk_en_lat_stg2;
	logic gatedClock1, gatedClock2;

	//produce the gated clocks
	and and1(gatedClock1, clk, clk_en_lat),
		and2(gatedClock2, clk, clk_en_lat_stg2);
		
	///////////////////////////////////////////
	// Generate and flop product if enabled //
	/////////////////////////////////////////
	always_ff @(posedge gatedClock1) begin
		  prod_reg <= A*B;
	end
	/////////////////////////////////////////////////////
	// Pipeline the enable signal to accumulate stage //
	///////////////////////////////////////////////////
	always_ff @(posedge clk)
		en_stg2 <= en;
		
		
	//first gated clk
	always @(clk, en) begin
		if (!clk) clk_en_lat <= en;
	end

	//second gated clk
	always @(clk, en_stg2) begin
		if (!clk) clk_en_lat_stg2 <=  (en_stg2 | clr); //if en_stg2 is high OR clr signal is high, propagate a 1
	end

	always_ff @(posedge gatedClock2) begin
		if (clr)
		  accum <= 64'h0000000000000000;
		else
		  accum <= accum + prod_reg;
	end
	
endmodule
