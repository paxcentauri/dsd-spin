module part2(ClockIn, Reset, Speed, CounterValue);		//top level
	input ClockIn, Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	wire [10:0] CountRate, rateDivider;
	wire en;
	selectSpeed s(.Speed(Speed),.selectedSpeed(CountRate));
	rateDiv r(.CountRate(CountRate),.Clock(ClockIn),.Reset(Reset),.enable(en),.RateDivider(rateDivider));
	hexaCounter h(.Clock(ClockIn), .Reset(Reset), .Enable(en), .Q(CounterValue));
endmodule
module selectSpeed(input [1:0] Speed, output reg [10:0] selectedSpeed);		//selects speeds
	always @ (*)
		begin
			case(Speed)
				2'b00: selectedSpeed = 0;		//0
				2'b01: selectedSpeed = 11'b111110011;		//binary equivalent of 50mil-1
				2'b10: selectedSpeed = 11'b1111100111;		//binary equivalent of 100mil-1
				2'b11: selectedSpeed = 11'b11111001111;	//binary equivalent of 200mil-1
			endcase
		end
endmodule
module rateDiv(input [10:0] CountRate, input Clock, Reset, output enable, output reg[10:0] RateDivider);
	always @(posedge Clock)		//synchronous
		begin
			if(Reset==1)		//active high
				RateDivider<=0;
			else if(RateDivider==0)		//when finally down to 0, load countrate
				RateDivider<=CountRate;
			else
				RateDivider<=RateDivider-1;		//keep counting down by 1 until 0
		end
	assign enable = (RateDivider==11'b00000000000)?1:0;		//enable = 1 when ratediv = 0
endmodule

module hexaCounter(input Clock, Reset, Enable, output reg [3:0] Q);		
	always @(posedge Clock)		//synchronous
		begin
			if(Reset==1)	//active high
				Q<=4'b0000;
			else if(Q == 4'b1111)		//when counted all, reset
				Q<=4'b0000;
			else if(Enable==1)		//count up
				Q<=Q+1;
		end
endmodule
