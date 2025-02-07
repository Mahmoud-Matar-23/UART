module UART_Fsm #(parameter width=8)
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire    	 	Rx_in,
input wire    	 	Parity_En,
input wire    	 	Parity_err,
input wire    	 	Start_err,
input wire    	 	Stop_err,
input wire [5:0] 	Prescale,
input wire [5:0] 	edgecount,
input wire [3:0] 	bit_count,
output reg    	 	Deser_en,
output reg    	 	Edge_count_en,
output reg    	 	Parity_chk_en,
output reg    	 	Stop_chk_en,
output reg    	 	Start_chk_en,
output reg    	 	Data_sampling_en,
output reg    	 	Data_Valid
);

parameter [2:0] Idle=3'b000,
		Start=3'b001,
		Data=3'b010,
		Parity=3'b011,
		Stop=3'b100,
		Error_chk=3'b101;

reg [2:0]       Current_state,Next_state;

wire        [5:0]      check_edge , 
                       error_check_edge; 

assign check_edge=Prescale-1;
assign error_check_edge=Prescale-2;


always @(posedge Clk  or negedge Rst) begin  // Current State 

	if(!Rst)
		Current_state<=Idle;
	else 
		Current_state<=Next_state;

end

always @(*) begin   //Next State

	case(Current_state)

	 Idle: begin

		if(!Rx_in)
			Next_state<=Start;
		else
			Next_state<=Idle;

	 end
	 Start: begin
		if((bit_count==0)&&(edgecount==check_edge)) begin

		  if(!Start_err)
			Next_state<=Data;
		  else 
			Next_state<=Idle;
		end
		else
			Next_state<=Start;
	 end
	 Data: begin
		if((bit_count=='d8)&&(edgecount==check_edge)) begin

		  if(Parity_En)
			Next_state<=Parity;
		  else 
			Next_state<=Stop;
		end
		else
			Next_state<=Data;

	 end
	 Parity: begin
		if((bit_count=='d9)&&(edgecount==check_edge)) 
			Next_state<=Stop;
		
		else
			Next_state<=Parity;
	 end
	 Stop: begin
		if(Parity_En) begin
		   if((bit_count=='d10)&&(edgecount==error_check_edge)) 
			Next_state<=Error_chk;
		   
		   else
			Next_state<=Stop;
		end
		else
		   if((bit_count=='d9)&&(edgecount==error_check_edge)) 
			Next_state<=Error_chk;
		   
		   else
			Next_state<=Stop;

	 end
	 Error_chk: begin
		if(!Rx_in)
			Next_state<=Start;
		else
			Next_state<=Idle;

	 end
	 default: begin

		Next_state<=Idle;

	 end
	endcase
end


always @(*) begin   //Output

   	 Edge_count_en<=0;
   	 Parity_chk_en<=0;
    	 Stop_chk_en<=0;
    	 Start_chk_en<=0;
    	 Data_sampling_en<=0;
  	 Data_Valid<=0;
	 Deser_en<=0;

	case(Current_state)

	 Idle: begin

	 	if(!Rx_in) begin
	 	  Edge_count_en<=1;
   	 	  Parity_chk_en<=0;
    	 	  Stop_chk_en<=0;
    	 	  Start_chk_en<=1;
    	 	  Data_sampling_en<=1;
  	 	  Data_Valid<=0;
		  Deser_en<=0;
	 	end
	
	 	else begin
	 	  Edge_count_en<=0;
   	 	  Parity_chk_en<=0;
    	 	  Stop_chk_en<=0;
    	 	  Start_chk_en<=0;
    	 	  Data_sampling_en<=0;
  	 	  Data_Valid<=0;
		  Deser_en<=0;
	 	end

	 end
	 Start: begin

	 	Edge_count_en<=1;
   		Parity_chk_en<=0;
    	 	Stop_chk_en<=0;
    	 	Start_chk_en<=1;
    	 	Data_sampling_en<=1;
  	 	Data_Valid<=0;
		Deser_en<=0;

	 end
	 Data: begin

	 	Edge_count_en<=1;
   	 	Parity_chk_en<=0;
    	 	Stop_chk_en<=0;
    	 	Start_chk_en<=0;
    	 	Data_sampling_en<=1;
  	 	Data_Valid<=0;
		Deser_en<=1;

	 end
	 Parity: begin

	 	Edge_count_en<=1;
   	 	Parity_chk_en<=1;
    	 	Stop_chk_en<=0;
    	 	Start_chk_en<=0;
    	 	Data_sampling_en<=1;
  	 	Data_Valid<=0;
		Deser_en<=0;

	 end
	 Stop: begin

	 	Edge_count_en<=1;
   	 	Parity_chk_en<=0;
    	 	Stop_chk_en<=1;
    	 	Start_chk_en<=0;
    	 	Data_sampling_en<=1;
  	 	Data_Valid<=0;
		Deser_en<=0;
	 end
	 Error_chk: begin

	 	Edge_count_en<=0;
   	 	Parity_chk_en<=0;
    	 	Stop_chk_en<=0;
    	 	Start_chk_en<=0;
    	 	Data_sampling_en<=1;
		Deser_en<=0;
		
		if(Parity_err|Stop_err)
			Data_Valid<=0;
		else
			Data_Valid<=1;
	 end
	 default: begin

	 	Edge_count_en<=0;
   	 	Parity_chk_en<=0;
    	 	Stop_chk_en<=0;
    	 	Start_chk_en<=0;
    	 	Data_sampling_en<=0;
  	 	Data_Valid<=0;
		Deser_en<=0;

	 end


	endcase

end 

endmodule
