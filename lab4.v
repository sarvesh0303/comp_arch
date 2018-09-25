module mux21(out,sel,in1,in0);
	input in1,in0,sel;
	output out;
	wire nsel,w1,w0;
	not n1(nsel,sel);
	and a1(w0,nsel,in0);
	and a2(w1,sel,in1);
	or o1(out,w0,w1);
endmodule

module mux3port(out,sel,in2,in1,in0);
	input in2,in1,in0;
	output out;
	input [1:0] sel;
	wire [1:0] nsel;
	wire w1,w2,w0;
	not n1(nsel[1],sel[1]);
	not n2(nsel[0],sel[0]);
	and a0(w0,nsel[1],nsel[0],in0);
	and a1(w1,nsel[1],sel[0],in1);
	and a2(w2,sel[1],nsel[0],in2);
	or o1(out,w0,w1,w2);
endmodule


module bit32_mux21(out,sel,in1,in0);
	input [31:0] in1,in0;
	input sel;
	output [31:0] out;
	genvar j;
	generate for (j=0;j<32;j=j+1) begin: mux_loop
	mux21 m1(out[j],sel,in1[j],in0[j]);
	end
	endgenerate
endmodule

module bit32_mux3port(out,sel,in2,in1,in0);
	input [31:0] in2,in1,in0;
	output[31:0] out;
	input [1:0] sel;
	genvar j;
	generate for (j=0;j<32;j=j+1) begin: mux_loop32
		mux3port mj(out[j],sel,in2[j],in1[j],in0[j]);
	end
	endgenerate
endmodule

module bit32_and(out,in1,in2);
	input [31:0] in1,in2;
	output [31:0] out;
	assign {out}=in1 &in2;
endmodule

module bit32_or(out,in1,in2);
	input [31:0] in1,in2;
	output [31:0] out;
	assign {out}=in1|in2;
endmodule

module bit32_not(out,in);
	input [31:0] in;
	output [31:0] out;
	assign {out} = ~in;
endmodule

module FA_dataflow(cout,sum,in1,in2,cin);
 input in1,in2;
 input cin;
 output cout;
 output sum;
 assign {cout,sum}=in1+in2+cin;
endmodule

module bit32_FA(cout,sum,in1,in2,cin);
 input [31:0] in1,in2;
 input cin;
 output [31:0] sum;
 output cout;
 wire [32:0] carry;
 assign carry[0] = cin;
 genvar j;
 generate for (j=0;j<32;j=j+1) begin: adder_seq
 FA_dataflow faj(carry[j+1],sum[j],in1[j],in2[j],carry[j]);
 end
 endgenerate
 assign cout = carry[32];
endmodule

module ALU(a,b,bin,cin,op,res,cout);
 input [31:0] a,b;
 input cin,bin;
 input [1:0] op;
 output [31:0] res;
 output cout;
 wire [31:0] bfin,negb,min0,min1,min2;
 bit32_not n1(negb,b);
 bit32_mux21 m1(bfin,bin,negb,b);
 bit32_and a1(min0,a,bfin);
 bit32_or a2(min1,a,bfin);
 bit32_FA a3(cout,min2,a,bfin,cin);
 bit32_mux3port fin(res,op,min2,min1,min0);
endmodule

 
module tbALU();
reg Binvert, Carryin;
reg [1:0] Operation;
reg [31:0] a,b;
wire [31:0] Result;
wire CarryOut;
ALU a1(a,b,Binvert,Carryin,Operation,Result,CarryOut);
initial
begin
$monitor(,$time,"a = %h, b =%h, bin = %b, op = %b, cin = %b, res = %h, cout = %b",a,b,Binvert,Operation,Carryin,Result,CarryOut);
a=32'ha5a5a5a5;
b=32'h5a5a5a5a;
Operation=2'b00;
Binvert=1'b0;
Carryin=1'b0; //must perform AND resulting in zero
#100 Operation=2'b01; //OR
#100 Operation=2'b10; //ADD
#100 Binvert=1'b1;//SUB
#200 $finish;
end
endmodule

module ANDarray (RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp0,ALUOp1,Op);
input [5:0] Op;
output RegDst,ALUSrc,MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp0;
wire Rformat, lw,sw,beq;
assign Rformat= (~Op[0])& (~Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
assign lw = (Op[0])& (Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (Op[5]);
assign sw = (Op[0])& (Op[1])& (~Op[2])& (Op[3])& (~Op[4])& (Op[5]);
assign beq = (~Op[0])& (~Op[1])& (Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);

assign RegDst = Rformat;
assign ALUSrc = lw | sw;
assign MemtoReg = lw;
assign RegWrite = Rformat | lw;
assign MemRead = lw;
assign MemWrite = sw;
assign Branch = beq;
assign AluOp0 = Rformat;
assign AluOp1 = beq;
endmodule

module ALUControl(ALUC,AluOp,Funct);
output [2:0] ALUC;
input [1:0] AluOp;
input [3:0] Funct;
wire w1,w2;

or o1(w1,Funct[0],Funct[3]);
and a1(ALUC[0],w1,AluOp[1]);
nor n1(ALUC[1],AluOp[1],Funct[2]);
and a2(w2,AluOp[1],Funct[1]);
or o2(ALUC[2],AluOp[0],w2);

endmodule