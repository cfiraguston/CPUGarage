module Full_adder (A, B, Cin, S, Cout);
input A, B, Cin;
output S, Cout;

// internal wires
wire ha1_sum, ha2_sum;
wire ha1_carry, ha2_carry;

// instance HA1
Half_adder HA1 (
	.A(A),
	.B(B),
	.Sum(ha1_sum),
	.Carry(ha1_carry)
	);

Half_adder HA2 (
	.A(Cin),
	.B(ha1_sum),
	.Sum(ha2_sum),
	.Carry(ha2_carry)
	);

// Assitn the sum output
assign S = ha2_sum;
assign Cout = ha1_carry | ha2_carry;

endmodule
