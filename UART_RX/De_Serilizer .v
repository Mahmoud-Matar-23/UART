module De_serializer#(parameter Width=8)
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire    	 	Sampled_bit,
input wire    	 	Deser_en,
input wire [5:0] 	Prescale,
input wire [5:0] 	edgecount,
output reg [Width-1:0] 	P_Data 
);

always @(posedge Clk or negedge Rst) begin
	
	if(!Rst)
		P_Data<=0;

	else if((Deser_en)&&(edgecount==(Prescale-1)))  begin

		P_Data<={Sampled_bit,P_Data[Width-1:1]};
	
	end

end

endmodule 
