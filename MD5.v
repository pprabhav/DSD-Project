module MD5(
	input reg[511:0] message,
	input wire clk,
	input wire reset,
	input wire start,
	output reg[127:0] digest,
	output wire done);
	
	
	reg A=32'h01234567;
   reg B=32'h89abcdef;
   reg C=32'hfedcba98;
   reg D=32'h76543210;
	
	reg[31:0] words[7:0];
	
	
	reg[43:0] T[63:0];
	always @(*) begin
		T[0] = 44'hD76AA478070; 
		T[1] = 44'hE8C7B7560C1; 		
		T[2] = 44'h242070DB112; 
		T[3] = 44'hC1BDCEEE163; 
		T[4] = 44'hF57C0FAF074; 
		T[5] = 44'h4787C62A0C5; 
		T[6] = 44'hA8304613116; 
		T[7] = 44'hFD469501167; 
		T[8] = 44'h698098D8078; 		
		T[9] = 44'h8B44F7AF0C9; 
		T[10] = 44'hFFFF5BB111A; 
		T[11] = 44'h895CD7BE16B; 
		T[12] = 44'h6B90112207C; 
		T[13] = 44'hFD9871930CD; 
		T[14] = 44'hA679438E11E; 
		T[15] = 44'h49B4082116F; 		
	
		T[16] = 44'hf61e2562051; 
		T[17] = 44'hc040b340096; 
		T[18] = 44'h265e5a510EB; 
		T[19] = 44'he9b6c7aa140; 
		T[20] = 44'hd62f105d055; 
		T[21] = 44'h0244145309A; 
		T[22] = 44'hd8a1e6810EF; 		
		T[23] = 44'he7d3fbc8144; 
		T[24] = 44'h21e1cde6059; 
		T[25] = 44'hc33707d609E; 
		T[26] = 44'hf4d50d870E3; 
		T[27] = 44'h455a14ed148; 
		T[28] = 44'ha9e3e90505D; 
		T[29] = 44'hfcefa3f8092; 		
		T[30] = 44'h676f02d90E7; 
		T[31] = 44'h8d2a4c8a14C; 
		
		T[32] = 44'hfffa3942045; 
		T[33] = 44'h8771f6810B8; 
		T[34] = 44'h6d9d612210B; 
		T[35] = 44'hfde5380c17E; 
		T[36] = 44'ha4beea44041; 		
		T[37] = 44'h4bdecfa90B4; 
		T[38] = 44'hf6bb4b60107; 
		T[39] = 44'hbebfbc7017A; 
		T[40] = 44'h289b7ec604D; 
		T[41] = 44'heaa127fa0B0; 
		T[42] = 44'hd4ef3085103; 
		T[43] = 44'h04881d05176; 		
		T[44] = 44'hd9d4d039049; 
		T[45] = 44'he6db99e50BC; 
		T[46] = 44'h1fa27cf810F; 
		T[47] = 44'hc4ac5665172; 
		
		T[48] = 44'hf4292244060; 
		T[49] = 44'h432aff970A7; 
		T[50] = 44'hab9423a70FE; 		
		T[51] = 44'hfc93a039155; 
		T[52] = 44'h655b59c306C; 
		T[53] = 44'h8f0ccc920A3; 
		T[54] = 44'hffeff47d0FA; 
		T[55] = 44'h85845dd1151; 
		T[56] = 44'h6fa87e4f068; 
		T[57] = 44'hfe2ce6e00AF; 		
		T[58] = 44'ha30143140F6; 
		T[59] = 44'h4e0811a115D; 
		T[60] = 44'hf7537e82064; 
		T[61] = 44'hbd3af2350AB; 
		T[62] = 44'h2ad7d2bb0F2; 
		T[63] = 44'heb86d391159;	
	end
	
	
	
	