module dff_sync_clear(d, clearb,clock, q);
	input d, clearb, clock;
	output q;
	reg q;
	always @ (posedge clock)
	begin
		if (!clearb) q <= 1'b0;
		else q <= d;
	end
endmodule

module reg_32bit(q,d,clk,reset);
	input [31:0] d;
	input clk, reset;
	output[31:0] q;
	wire [31:0] q;
	genvar j;
	generate for (j=0; j<32; j=j+1) begin: dflip_iter
		dff_sync_clear dj(d[j],reset,clk,q[j]);
	end
	endgenerate
endmodule

/* module tb32reg;
reg [31:0] d;
reg clk,reset;
wire [31:0] q;
reg_32bit R(q,d,clk,reset);
always @(clk)
#5 clk<=~clk;
initial
begin
$monitor(,$time," in = %b, out = %b, reset=%b",d,q,reset);
clk= 1'b1;
reset=1'b0;//reset the register
#20 reset=1'b1;
#20 d=32'hAFAFAFAF;
#200 $finish;
end
endmodule */

module mux4_1(regData,q1,q2,q3,q4,reg_no);
	input [31:0] q1,q2,q3,q4;
	input [1:0] reg_no;
	output [31:0] regData;
	wire [31:0] w1,w2,w3,w4;
	wire [1:0] neg_reg;
	not n1(neg_reg[1],reg_no[1]);
	not n0(neg_reg[0],reg_no[0]);
	genvar j;
	generate for (j=0;j<32;j=j+1) begin: and_iter
		and s0(w1[j],q1[j],neg_reg[1],neg_reg[0]);
		and s1(w2[j],q2[j],neg_reg[1],reg_no[0]);
		and s2(w3[j],q3[j],reg_no[1],neg_reg[0]);
		and s3(w4[j],q4[j],reg_no[1],reg_no[0]);
		or fingate(regData[j],w1[j],w2[j],w3[j],w4[j]);
	end
	endgenerate
endmodule

module decoder2_4(register,reg_no);
	output [3:0] register;
	input [1:0] reg_no;
	wire [1:0] nreg;
	not n0(nreg[0],reg_no[0]);
	not n1(nreg[1],reg_no[1]);
	and a0(register[0],nreg[1],nreg[0]);
	and a1(register[1],nreg[1],reg_no[0]);
	and a2(register[2],reg_no[1],nreg[0]);
	and a3(register[3],reg_no[1],reg_no[0]);
endmodule

module RegFile(clk,reset,ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,ReadData1,ReadData2);
	output [31:0] ReadData1,ReadData2;
	input clk,reset,RegWrite;
	input [31:0] WriteData;
	input [1:0] ReadReg1,ReadReg2,WriteReg;
	wire [3:0] regclk,decreg;
	wire [31:0] q1,q2,q3,q0;
	genvar j;
	decoder2_4 d(decreg,WriteReg);
	generate for (j=0;j<4;j=j+1) begin: regbuild
		and aj(regclk[j],decreg[j],RegWrite,clk);
	end
	endgenerate
	reg_32bit r0(q0,WriteData,regclk[0],reset);
	reg_32bit r1(q1,WriteData,regclk[1],reset);
	reg_32bit r2(q2,WriteData,regclk[2],reset);
	reg_32bit r3(q3,WriteData,regclk[3],reset);
	mux4_1 m1(ReadData1,q0,q1,q2,q3,ReadReg1);
	mux4_1 m2(ReadData2,q0,q1,q2,q3,ReadReg2);
endmodule


module tbm41();
reg [31:0] r1,r2,r3,r4;
reg [1:0] rn;
wire[31:0] rD;
mux4_1 M41(rD,r1,r2,r3,r4,rn);
initial
begin 
$monitor(,$time,"out = %b, reset=%b",rD,rn);
r1 = 32'b11001100110011001100110011001100;
r2 = 32'b11110000111100001111000011110000;
r3 = 32'b11111111000000001111111100000000;
r4 = 32'b11111111111111110000000000000000;
#5 rn = 2'b00;
#10 rn = 2'b10;
#10 rn = 2'b11;
#5 rn = 2'b01;
#200 $finish;
end
endmodule
