module part1(Clock, Enable, Clear_b, CounterValue);
	input Clock, Enable, Clear_b;
	output reg [7:0] CounterValue;
	always @(posedge Clock, negedge Clear_b)
		begin
			if(Clear_b==0)
				CounterValue<=0;
			else if(Enable==1)
				CounterValue<=CounterValue+1;
		end
endmodule
