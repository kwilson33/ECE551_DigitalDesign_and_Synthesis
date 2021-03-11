module oscillator(OUT,EN);
/////////////////////////////////////////////
// Ring oscillator //
// delay = 5 time units // 
// When en is low count freezes.     //
//////////////////////////////////////

output OUT;	
input  EN;	

wire n1,n2;

nand #5 nand1(n1,EN,OUT);
not #5  not1(n2,n1),
        not2(OUT,n2);
	  
endmodule
