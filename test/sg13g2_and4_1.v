`timescale 1ns/10ps
`celldefine
module sg13g2_and4_1 (X, A, B, C, D);
	output X;
	input A, B, C, D;
	and (X, A, B, C, D);
endmodule
`endcelldefine
