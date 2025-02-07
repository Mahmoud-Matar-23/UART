module Data_Sampling
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire    	 	Rx_In,
input wire    	 	Data_sam_en,
input wire [5:0] 	Prescale,
input wire [5:0] 	edgecount,
output reg 	 	Sampled_bit 
);

reg  [2:0] Samples;
wire [4:0] half_edge,half_edge_n1,half_edge_p1;

assign half_edge=(Prescale>>1)-1;
assign half_edge_n1=half_edge-1;
assign half_edge_p1=half_edge+1;


always@(posedge Clk or negedge Rst)begin
    if(!Rst)
		Samples<=3'b0;

    else if(Data_sam_en) begin

	if(half_edge==edgecount) begin
		Samples[0]<=Rx_In;
	end
	else if(half_edge_n1==edgecount) begin
		Samples[1]<=Rx_In;
	end
	else if(half_edge_p1==edgecount) begin
		Samples[2]<=Rx_In;
	end

     end

     else
		Samples<=3'b0;

end


always@(posedge Clk or negedge Rst)begin
	if(!Rst)
		Sampled_bit<=0;

	else if (Data_sam_en) begin

		case(Samples) 
		3'b000:Sampled_bit<=0;
		3'b001:Sampled_bit<=0;
		3'b010:Sampled_bit<=0;
		3'b011:Sampled_bit<=1;
		3'b100:Sampled_bit<=0;
		3'b101:Sampled_bit<=1;
		3'b110:Sampled_bit<=1;
		3'b111:Sampled_bit<=1;
		endcase
	end
	else
		Sampled_bit<=0;


end

endmodule
