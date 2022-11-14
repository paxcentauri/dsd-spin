module part2(Clock, Reset_b, Data, Function, ALUout);
	input [3:0] Data;
	input [2:0] Function;
	input Reset_b, Clock;
	wire [7:0] aluresult;
	output reg [7:0] ALUout;
	ALU a(.A(Data), .B(ALUout[3:0]),.Function(Function),.ALUout(aluresult),.holdValue(ALUout));
	always @(posedge Clock)
		begin
			if(Reset_b==0)
				ALUout<=8'b00000000;
			else
				ALUout<=aluresult;
		end
endmodule
				
module ALU(A, B, Function, ALUout,holdValue);
		input [3:0] A, B;
		input [2:0] Function;
		output reg [7:0] ALUout;
		input [7:0] holdValue;
		wire [4:0] sum, c1;
		fourbitadder sumab(.a(A), .b(B), .c_in(0), .s(sum), .c_out(c1));
		always @(*)
		begin
			case(Function)
				3'b000: ALUout <= {3'b000, sum[4:0]};		//from adder in l2p3
				3'b001: ALUout = A+B;		//unchanged from l3p3
				3'b010: ALUout = {B[3],B[3],B[3],B[3], B};		//unchanged from l3p3
				3'b011: ALUout = ((|A)|(|B))?(8'b00000001):(8'b00000000);//unchanged from l3p3
				3'b100: ALUout = ((&A)&(&B))?(8'b00000001):(8'b00000000);//unchanged from l3p3
				3'b101: ALUout = B<<A;
				3'b110: ALUout = A*B;
				3'b111: ALUout = holdValue;
				default: ALUout = 8'b00000000;
			endcase
		end
endmodule
				
module fourbitadder(a, b, c_in, s, c_out);
	input [3:0] a, b;
	input c_in;
	wire [4:0] c1, c2, c3;
	output [4:0] s;
	output [3:0] c_out;
	fa fa0(.a(a[0]),.b(b[0]),.ci(c_in),.so(s[0]),.co(c1));
	fa fa1(.a(a[1]),.b(b[1]),.ci(c1),.so(s[1]),.co(c2));
	fa fa2(.a(a[2]),.b(b[2]),.ci(c2),.so(s[2]),.co(c3));
	fa fa3(.a(a[3]),.b(b[3]),.ci(c3),.so(s[3]),.co(c_out[3]));
	assign s[4] = c_out[3];
	assign c_out[0] = c1;
	assign c_out[1] = c2;
	assign c_out[2] = c3;
endmodule
	
module fa(a,b,ci,so,co);
	input a,b,ci;
	output so,co;
	assign so = a^b^ci;
	assign co = ((a&b)|(a&ci)|(b&ci));
endmodule
	
