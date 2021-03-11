module masterSlaveFF (q, d, clk);
//Kevin Wilson

//Master-Slave FF using tristates
//Master circuit triggers on leading edge of the clock
//Slave circuit triggers on falling edge of the clock

output q;
input d,clk;

wire md,mq,sd;


not master_inverter1(mq, md),
	slave_inverter1(q, sd);

//weak inverters to allow new input to change held value
not (weak0, weak1) master_inverter2(md, mq),
				   slave_inverter2(sd, q);


//When clock is high, input is stored in first latch (master) but second latch (slave) can't change
//When clock is low,  master's output is stored in slave latch, but master output can't change
notif1 #1 master_tristate(md, d, clk),
	      slave_tristate(sd, mq, !clk);
		
endmodule


