module Stop_check 
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire    	 	Sampled_bit,
input wire    	 	Stop_en,
output reg 	 	Stop_err 
);



always @(posedge Clk or negedge Rst) begin
	if(!Rst)
		Stop_err<=0;

	else if(Stop_en) begin
		if(Sampled_bit==1)
			Stop_err<=0;
		else
			Stop_err<=1;
	
	end
	else
		Stop_err<=0;
end

endmodule
