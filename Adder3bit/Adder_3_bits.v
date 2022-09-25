module Adder_3_bits (
	input [2:0] a, b,
	output [2:0] Sum,
	output Carry);
	
// Ripple bus
wire [1:0] ripple;

Full_adder FA0 (
	.A(a[0]),
	.B(b[0]),
	.Cin(1'b0),
	.S(Sum[0]),
	.Cout(ripple[0]));
	
Full_adder FA1 (
	.A(a[1]),
	.B(b[1]),
	.Cin(ripple[0]),
	.S(Sum[1]),
	.Cout(ripple[1]));
	
Full_adder FA2 (
	.A(a[2]),
	.B(b[2]),
	.Cin(ripple[1]),
	.S(Sum[2]),
	.Cout(Carry));
	
endmodule
