module MD5(
	
	// change message length if needed

	input reg[1535:0] message,
	input [10:0] length,
	input wire clk,
	input wire reset,
	input wire start,
	output reg[127:0] digest,
	output wire done);
	
	reg [511:0] s_msgs[0:3];
	reg [2047:0] padded_msg;
	
	
	reg[31:0] words[0:15]; 
   reg [63:0] message_len;          
          
   reg done_reg; 
	reg [6:0] block_count;  
	
	reg[32:0] K[0:63];
	reg [5:0] s[0:63];

	 
	always @(*) begin
		
		
			// Round 1: s[0..15]
		s[0]  = 32'd7;   s[1]  = 32'd12;  s[2]  = 32'd17;  s[3]  = 32'd22;
		s[4]  = 32'd7;   s[5]  = 32'd12;  s[6]  = 32'd17;  s[7]  = 32'd22;
		s[8]  = 32'd7;   s[9]  = 32'd12;  s[10] = 32'd17;  s[11] = 32'd22;
		s[12] = 32'd7;   s[13] = 32'd12;  s[14] = 32'd17;  s[15] = 32'd22;
		
		// Round 2: s[16..31]
		s[16] = 32'd5;   s[17] = 32'd9;   s[18] = 32'd14;  s[19] = 32'd20;
		s[20] = 32'd5;   s[21] = 32'd9;   s[22] = 32'd14;  s[23] = 32'd20;
		s[24] = 32'd5;   s[25] = 32'd9;   s[26] = 32'd14;  s[27] = 32'd20;
		s[28] = 32'd5;   s[29] = 32'd9;   s[30] = 32'd14;  s[31] = 32'd20;
		
		// Round 3: s[32..47]
		s[32] = 32'd4;   s[33] = 32'd11;  s[34] = 32'd16;  s[35] = 32'd23;
		s[36] = 32'd4;   s[37] = 32'd11;  s[38] = 32'd16;  s[39] = 32'd23;
		s[40] = 32'd4;   s[41] = 32'd11;  s[42] = 32'd16;  s[43] = 32'd23;
		s[44] = 32'd4;   s[45] = 32'd11;  s[46] = 32'd16;  s[47] = 32'd23;
		
		// Round 4: s[48..63]
		s[48] = 32'd6;   s[49] = 32'd10;  s[50] = 32'd15;  s[51] = 32'd21;
		s[52] = 32'd6;   s[53] = 32'd10;  s[54] = 32'd15;  s[55] = 32'd21;
		s[56] = 32'd6;   s[57] = 32'd10;  s[58] = 32'd15;  s[59] = 32'd21;
		s[60] = 32'd6;   s[61] = 32'd10;  s[62] = 32'd15;  s[63] = 32'd21;
		
		
		// Round 1
		K[0]  = 32'hd76aa478;  K[1]  = 32'he8c7b756;  K[2]  = 32'h242070db;  K[3]  = 32'hc1bdceee;
		K[4]  = 32'hf57c0faf;  K[5]  = 32'h4787c62a;  K[6]  = 32'ha8304613;  K[7]  = 32'hfd469501;
		K[8]  = 32'h698098d8;  K[9]  = 32'h8b44f7af;  K[10] = 32'hffff5bb1;  K[11] = 32'h895cd7be;
		K[12] = 32'h6b901122;  K[13] = 32'hfd987193;  K[14] = 32'ha679438e;  K[15] = 32'h49b40821;
		
		// Round 2
		K[16] = 32'hf61e2562;  K[17] = 32'hc040b340;  K[18] = 32'h265e5a51;  K[19] = 32'he9b6c7aa;
		K[20] = 32'hd62f105d;  K[21] = 32'h02441453;  K[22] = 32'hd8a1e681;  K[23] = 32'he7d3fbc8;
		K[24] = 32'h21e1cde6;  K[25] = 32'hc33707d6;  K[26] = 32'hf4d50d87;  K[27] = 32'h455a14ed;
		K[28] = 32'ha9e3e905;  K[29] = 32'hfcefa3f8;  K[30] = 32'h676f02d9;  K[31] = 32'h8d2a4c8a;
		
		// Round 3
		K[32] = 32'hfffa3942;  K[33] = 32'h8771f681;  K[34] = 32'h6d9d6122;  K[35] = 32'hfde5380c;
		K[36] = 32'ha4beea44;  K[37] = 32'h4bdecfa9;  K[38] = 32'hf6bb4b60;  K[39] = 32'hbebfbc70;
		K[40] = 32'h289b7ec6;  K[41] = 32'heaa127fa;  K[42] = 32'hd4ef3085;  K[43] = 32'h04881d05;
		K[44] = 32'hd9d4d039;  K[45] = 32'he6db99e5;  K[46] = 32'h1fa27cf8;  K[47] = 32'hc4ac5665;
		
		// Round 4
		K[48] = 32'hf4292244;  K[49] = 32'h432aff97;  K[50] = 32'hab9423a7;  K[51] = 32'hfc93a039;
		K[52] = 32'h655b59c3;  K[53] = 32'h8f0ccc92;  K[54] = 32'hffeff47d;  K[55] = 32'h85845dd1;
		K[56] = 32'h6fa87e4f;  K[57] = 32'hfe2ce6e0;  K[58] = 32'ha3014314;  K[59] = 32'h4e0811a1;
		K[60] = 32'hf7537e82;  K[61] = 32'hbd3af235;  K[62] = 32'h2ad7d2bb;  K[63] = 32'heb86d391;
		
		// Initialize variables:
		reg a0 = 0x67452301   // A
		reg b0 = 0xefcdab89   // B
		reg c0 = 0x98badcfe   // C
		reg d0 = 0x10325476   // D
		
		padded_msg[0:length]=message[0:length];
		padded_msg[0:length+1]=1'b1;
		for (k=length; k<1984; k=k+1) begin
			padded_msg[k]=1'b0;
		end
		padded_msg[1984:2035]=53'b0;
		padded_msg[2036:2047]=length;
		for (m=0; m<4; m=m+1) begin
			s_msgs[m]=padded_msg[512*m:511*(m+1)];
		
			for (j=15; j<=0; j=j-1) begin	
		
				words[j]=s_msgs[m][(j+1)*32-1:j*32];
				
			end
				
				reg A=32'h01234567;
				reg B=32'h89abcdef;
				reg C=32'hfedcba98;
				reg D=32'h76543210;
				
				for (n=0; n<=63; n=n+1) begin
					reg F;
					reg g;
					if (n<16)
						 F = (B & C) | ((~B) & D);
						 g = n;
					else if (n<32) 
						F = (D & B) | ((~D) & C);
						g = (5*n + 1)%16;
						
					else if (n<48)
						F = B^C^D;
						g = (3*n + 5)% 16;
				
					else
						F = C^ (B | (~D));
						g = (7*n)% 16;
						
					F = F + A + K[n] + words[g];
					A = D;
					D = C;
					C = B;
					B = B + {F[s[n]-1:0], F[31:s[n]]};
				end
				
				a0 = a0 + A;
				b0 = b0 + B;
				c0 = c0 + C;
				d0 = d0 + D;
				
			end
			
		digest={a0, b0, c0, d0};
	end
end
	

