module PLA(NS,PCW,PCWC,ID,MR,MW,IRW,M2R,PCS,AOP,ASRCB,ASRCA,RW,RD,S,OP);
	output [3:0] NS;
	output [1:0] ASRCB,AOP,PCS;
	output PCW,PCWC,ID,MR,MW,IRW,M2R,ASRCA,RW,RD;
	input [5:0] OP;
	input [3:0] S;
	wire [16:0] VERT;
	#2
	assign VERT[0] = (~S[0])&(~S[1])&(~S[2])&(~S[3]);
	assign VERT[1] = (S[0])&(~S[1])&(~S[2])&(~S[3]);
	assign VERT[2] = (~S[0])&(S[1])&(~S[2])&(~S[3]);
	assign VERT[3] = (S[0])&(S[1])&(~S[2])&(~S[3]);
	assign VERT[4] = (~S[0])&(~S[1])&(S[2])&(~S[3]);
	assign VERT[5] = (S[0])&(~S[1])&(S[2])&(~S[3]);
	assign VERT[6] = (~S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[7] = (S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[8] = (~S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[9] = (S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[10] = (S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[11] = (S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[12] = (S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[13] = (~S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[14] = (S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[15] = (S[0])&(S[1])&(S[2])&(~S[3]);
	assign VERT[16] = (~S[0])&(S[1])&(S[2])&(~S[3]);
	