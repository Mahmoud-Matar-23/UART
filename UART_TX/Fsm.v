module Fsm 
(
 input   wire                  CLK,
 input   wire                  RST,
 input   wire                  Data_Valid,
 input   wire                  Ser_Done, 
 input   wire                  Parity_En,
 output  reg          [1:0]    Mux_sel,
 output  reg                   Busy,
 output  reg                   Ser_En 
);
parameter [2:0] Idle   =3'b000,
	        Start  =3'b001,
		Data   =3'b010,
		Parity =3'b011,
		Stop   =3'b100;

reg [2:0] Current_State,Next_State;

reg Busy_reg;


always@(posedge CLK or negedge RST) begin

	if(!RST)	
		Current_State<=Idle;
	else 		
		Current_State<=Next_State;

end

always@(*) begin

	case(Current_State)
		Idle   : begin
			  if(Data_Valid)
				Next_State<=Start;
			  else 
				Next_State<=Idle;
			 end 

		Start  : begin
				Next_State<=Data;
			 end 

		Data   : begin
			   if(Ser_Done) begin

			        if(Parity_En)
				  Next_State<=Parity;
			        else 
				  Next_State<=Stop;
			   end

			   else
				Next_State<=Data;

			 end 

		Parity : begin
				Next_State<=Stop;
			 end

		Stop   : begin
				Next_State<=Idle;
			 end
		
		default: begin
				Next_State<=Idle;
			 end
	endcase
end

always@(*) begin

     	Mux_sel  <=2'b00;
        Busy_reg <=1'b0 ;
        Ser_En   <=1'b0 ;

	case(Current_State)
		Idle   : begin
			      Mux_sel  <=2'b11;
                   	      Busy_reg <=1'b0;
                  	      Ser_En   <=1'b0;
			 end 

		Start  : begin
			      Mux_sel  <=2'b00;
                   	      Busy_reg <=1'b1 ;
                  	      Ser_En   <=1'b0 ;
			 end 

		Data   : begin

			    Mux_sel  <=2'b01;
                   	    Busy_reg <=1'b1 ;
                  	    Ser_En   <=1'b1 ;

			   if(Ser_Done) 
			        Ser_En   <=1'b0 ;
			   else
				Ser_En   <=1'b1 ;

			 end 

		Parity : begin

			    Mux_sel  <=2'b10;
                   	    Busy_reg <=1'b1 ;
                  	    Ser_En   <=1'b0 ;

			 end

		Stop   : begin
			    Mux_sel  <=2'b11;
                   	    Busy_reg <=1'b1 ;
                  	    Ser_En   <=1'b0 ;

			 end
		
		default: begin
			    Mux_sel  <=2'b00;
                   	    Busy_reg <=1'b0 ;
                  	    Ser_En   <=1'b0 ;

			 end
	endcase
end

always@(posedge CLK or negedge RST) begin

	if(!RST)	
		Busy<=0;
	else 		
		Busy<=Busy_reg;
end


endmodule

