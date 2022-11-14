module mux2to1(x,y,s,m);
	input x,y,s;
	output m;
	wire n, a1, a2;
	v7404 u1(.pin1(s), .pin2(n));
	v7408 u2(.pin1(x), .pin2(n), .pin3(a1));
	v7408 u3(.pin4(y), .pin5(s), .pin6(a2));
	v7432 u4(.pin1(a1), .pin2(a2), .pin3(m));
endmodule

module v7404(pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
	input pin1, pin3, pin5, pin9, pin11, pin13;
	output pin2, pin4, pin6, pin8, pin10, pin12;
	assign pin2 = ~pin1;
	assign pin4 = ~pin3;
	assign pin6 = ~pin5;
	assign pin8 = ~pin9;
	assign pin10 = ~pin11;
	assign pin12 = ~pin13;
endmodule

module v7408(pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
	input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
	output pin3, pin6, pin8, pin11;
	assign pin3 = pin1 & pin2;
	assign pin6 = pin4 & pin5;
	assign pin8 = pin9 & pin10;
	assign pin11 = pin12 & pin13;
endmodule

module v7432(pin1, pin3, pin5, pin9, pin11, pin13, pin2, pin4, pin6, pin8, pin10, pin12);
	input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13;
	output pin3, pin6, pin8, pin11;
	assign pin3 = pin1 | pin2;
	assign pin6 = pin4 | pin5;
	assign pin8 = pin9 | pin10;
	assign pin11 = pin12 | pin13;
endmodule

