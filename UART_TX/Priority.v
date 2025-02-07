module parity # ( parameter WIDTH = 8 )

(
 input   wire                  CLK,
 input   wire                  RST,
 input   wire                  parity_enable,
 input   wire                  parity_type,
 input   wire                  Busy, 
 input   wire   [WIDTH-1:0]    DATA,
 input   wire                  Data_Valid,
 output  reg                   parity 
);
reg [WIDTH-1:0]    DATA_v;


always@(posedge CLK or negedge RST) begin

	if(!RST)
		DATA_v<=0;
	else if(Data_Valid && !Busy)  
                DATA_v<=DATA;
end    

always@(posedge CLK or negedge RST) begin

	if(!RST)
		parity<=0;
	else if(parity_enable) begin 

		if(parity_type)
			parity<=~^DATA_v;          //odd parity 
		else
			parity<=^DATA_v;         //even parity
	end 
                
end    
endmodule
