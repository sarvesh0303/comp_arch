module test_multidim(out,in);
	output [1:0][3:0] out;
	input [3:0] in;
	assign out[1][3] = in[3];
endmodule

/* module RegFile32(clk,reset,ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,ReadData1,ReadData2);
	output [31:0] ReadData1,ReadData2;
	input clk,reset,RegWrite;
	input [31:0] WriteData;
	input [1:0] ReadReg1,ReadReg2,WriteReg;
	wire [3:0] regclk,decreg;
	wire [3:0] [31:0] q;
	genvar j;
	decoder2_4 d(decreg,WriteReg);
	generate for (j=0;j<4;j=j+1) begin: regbuild
		and aj(regclk[j],decreg[j],RegWrite,clk);
		reg_32bit rj(q[j],WriteData,regclk[j],reset);
	end
	endgenerate
	mux4_1 m1(ReadData1,q[0],q[1],q[2],q[3],ReadReg1);
	mux4_1 m2(ReadData2,q[0],q[1],q[2],q[3],ReadReg2);
endmodule */

module decoder5_32(out,in);
	output [31:0] out;
	input [4:0] in;
	assign out[in[4]*16+in[3]*8+in[2]*4+in[1]*2+in[0]]=1'b1;
endmodule