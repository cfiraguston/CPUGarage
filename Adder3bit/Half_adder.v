module Half_adder (A, B, Sum, Carry);
input A;
input B;
output Sum, Carry;

assign Sum = A ^ B;
assign Carry = A | B;

endmodule
