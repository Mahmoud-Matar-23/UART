module Parity_check #(parameter Width=8)
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire    	 	Sampled_bit,
input wire    	 	Parity_en,
input wire 	 	Parity_Typ,
input wire [Width-1:0] 	P_Data,
output reg 	 	Parity_err 
);

reg Parity_calc;

always @(*) begin
	if(Parity_Typ)  Parity_calc<=~(^P_Data);
	else		Parity_calc<=(^P_Data);
end

always @(posedge Clk or negedge Rst) begin
	if(!Rst)
		Parity_err<=0;

	else if(Parity_en) begin
		if(Parity_calc==Sampled_bit)
			Parity_err<=0;
		else
			Parity_err<=1;
	
	end
	else
		Parity_err<=0;
end

endmodule
