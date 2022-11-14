module part3(ClockIn, Resetn, Start, Letter, DotDashOut);
	input ClockIn, Resetn, Start;
	input [2:0] Letter;
	wire en;
	output reg DotDashOut;
	reg [11:0] binRep, temp;		//binRep: alphabet storage in binary; temp: shift reg handling
	wire [7:0] rateDivider;
	rateDiv r1(.Clock(ClockIn), .Reset(Resetn), .enable(en), .RateDivider(rateDivider));		//to get the enable signal from the rate div (in en)
	always @ (*)
		begin
			case(Letter)
            3'b000: binRep = 12'b101110000000; //A
            3'b001: binRep = 12'b111010101000; //B
            3'b010: binRep = 12'b111010111010; //C
            3'b011: binRep = 12'b111010100000; //D
            3'b100: binRep = 12'b100000000000; //E
            3'b101: binRep = 12'b101011101000; //F
            3'b110: binRep = 12'b111011101000; //G
            3'b111: binRep = 12'b101010100000; //H
				default: binRep = 12'b00000000000;
			endcase
		end
	always @(posedge ClockIn)
		begin
			if(Resetn==0 || Start==1)		//when resetn 0 or start1, load the letter into temp for shift reg handling
				begin
					DotDashOut<=0;
					temp<=binRep;
				end
			else if(en==1)		//enable is on, begin shifting in the 12 bit shift reg
				begin
					DotDashOut<=temp[11];
					temp<=temp<<1;
					temp[0]<=temp[11];
				end
		end
endmodule

module rateDiv(input Clock, Reset, output enable, output reg[7:0] RateDivider);
	always @(posedge Clock)		//synchronous
		begin
			if(Reset==0)		//active low
				RateDivider<=0;
			else if(RateDivider==0)		//when finally down to 0, goback to initial clock cycle counting, 250 Hz since we are using 0.5
				RateDivider<=8'b11111001;
			else
				RateDivider<=RateDivider-1;		//keep counting down by 1 until 0
		end
	assign enable = (RateDivider==8'b00000000)?1:0;		//enable = 1 when ratediv = 0
endmodule



