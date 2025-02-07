module Edge_bit_counter 
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire 	   	Enable,
input wire [5:0] 	Prescale,
output reg [3:0]	Bit_count,
output reg [5:0]	Edge_count 
);

wire edge_done;

assign edge_done= (Edge_count==Prescale-6'b1)? 1'b1 : 1'b0; 

always @(posedge Clk or negedge Rst) begin
	
	if(!Rst) begin
		Bit_count<=0;
	end
	else if(Enable) begin

		if(edge_done) begin

			Bit_count<=Bit_count+1;
		end


	end
	
	else begin
		Bit_count<=0;
	end

end


always @(posedge Clk or negedge Rst) begin
	
	if(!Rst) begin
		Edge_count<=0;
	end
	else if(Enable) begin

		if(edge_done) begin

			Edge_count<=0;
		end

		else begin

		Edge_count<=Edge_count+1;

		end
	end
	
	else begin
		Edge_count<=0;
	end

end

endmodule