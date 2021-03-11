module up_dwn_cnt4(clk, rst_n, dwn, en, cnt);

	//if dwn is high, count down, if low count up
	input rst_n, clk, en, dwn;
	output logic [3:0] cnt; //4 bit output
	
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n)
			cnt <= 4'h0;
		 else if (en) 
			if (dwn)
				cnt <= cnt - 1; //count down
			else	
				cnt <= cnt + 1; //count up
	end
endmodule



