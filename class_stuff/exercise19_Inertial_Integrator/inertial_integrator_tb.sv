//Kevin Wilson and Shaoheng Zhou
module inertial_integrator_tb();
	
	logic clk, rst_n, vld;
	logic [15:0] ptch_rt, AZ;
	wire [15:0] ptch;
	
	localparam PTCH_RT_OFFSET = 16'h03C2;

	inertial_integrator iDUT (.clk(clk), .rst_n(rst_n), .vld(vld), .ptch_rt(ptch_rt), .ptch(ptch), .AZ(AZ));
	
	initial begin
		clk = 0;
		rst_n = 0;
		@(posedge clk)
		@(negedge clk)
		rst_n = 1;					//deassert reset
		
		//## Test 1#### 
		//Pitch output should get more and more negative since we are integrating the 
		// negative of ptch_rt
		vld = 1;
		ptch_rt = 16'h1000 + PTCH_RT_OFFSET;
		AZ = 16'h0000;
		repeat (500) @(posedge clk);
		
		//## Test 2#### 
		//Ptch reading should trend back towards zero
		ptch_rt = PTCH_RT_OFFSET; //zero pitch rate because in DUT  assign ptch_rt_comp = ptch_rt - PTCH_RT_OFFSET;
		repeat (1000) @(posedge clk);
		
		//## Test 3#### 
		//Ptch reading should trend positively
		ptch_rt = PTCH_RT_OFFSET - 16'h1000;
		repeat (500) @(posedge clk);
		
		//## Test 4#### 
		//Zero pitch rate again. Trend towards zero
		ptch_rt = PTCH_RT_OFFSET;
		repeat (1000) @(posedge clk);
		
		//## Test 5#### 
		//When ptch gets to ~100 it should level off 
		// because ptch from AZ should match that from fusion and offset
		// should toggle between -512, +512
		AZ = 16'h0800;
		repeat (1000) @(posedge clk);
		$stop();
	end
	
	

	always begin
		#5 clk = ~clk;
	end



endmodule