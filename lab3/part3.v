module part3(A, B, Function, ALUout);
		input [3:0] A, B;
		input [2:0] Function;
		output reg [7:0] ALUout;
		wire [4:0] sum;
		part2 sumab(.a(A), .b(B), .c_in(0), .s(sum[3:0]), .c_out(sum[4]));
		always @(*)
		begin
			case(Function)
				3'b000: ALUout = {3'b000, sum[4:0]};
				3'b001: ALUout = A+B;
				3'b010: ALUout = {4'b0000, B};
				3'b011: ALUout = ((|A)|(|B))?(8'b00000001):(8'b00000000);
				3'b100: ALUout = ((&A)&(&B))?(8'b00000001):(8'b00000000);
				3'b101: ALUout = {A,B};
				default: ALUout = 8'b00000000;
			endcase
		end
endmodule
				
module part2(a, b, c_in, s, c_out);
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
	
module fa(a,b,ci,so,co);
	input a,b,ci;
	output so,co;
	assign so = a^b^ci;
	assign co = ((a&b)|(a&ci)|(b&ci));
endmodule
