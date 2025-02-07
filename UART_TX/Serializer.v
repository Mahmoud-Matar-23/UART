module Serializer # ( parameter WIDTH = 8 )

(
 input   wire                  CLK,
 input   wire                  RST,
 input   wire                  Ser_En,
 input   wire                  Busy, 
 input   wire   [WIDTH-1:0]    P_DATA,
 input   wire                  Data_Valid,
 output  wire                  Ser_Data,
 output  wire                  Ser_Done 
);
reg [WIDTH-1:0]    DATA_v ;
reg [2:0]          Counter;


always@(posedge CLK or negedge RST) begin

	if(!RST)
		DATA_v<=0;

	else if(Data_Valid && !Busy) 
 
                DATA_v<=P_DATA;

	else if(Ser_En)
	
		DATA_v<= DATA_v >> 1;
end    		


always@(posedge CLK or negedge RST) begin

	if(!RST)   Counter<=0;

	else begin

		if(Ser_En) 
			Counter<=Counter+1;

		else       
			Counter<=0;
        end        
end  
  
assign Ser_Data= DATA_v[0];
assign Ser_Done= (Counter== 3'b111) ? 1'b1:1'b0;

endmodule