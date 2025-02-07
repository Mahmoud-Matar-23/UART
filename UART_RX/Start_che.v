module Start_check 
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire    	 	Sampled_bit,
input wire    	 	Start_en,
output reg 	 	Start_err 
);



always @(posedge Clk or negedge Rst) begin
	if(!Rst)
		Start_err<=0;

	else if(Start_en) begin
		if(Sampled_bit==0)
			Start_err<=0;
		else
			Start_err<=1;
	
	end
	else
		Start_err<=0;
end

endmodule
