module UART #(parameter Width=8)
(

input wire       	  Clk,
input wire       	  Rst,
input wire                Data_Valid,
input wire  [Width-1:0]   P_Data,
input wire       	  Parity_En,
input wire       	  Parity_Typ,
output wire		  TX_out,
output wire		  Busy

);

wire Ser_done,Ser_en,Parity,Ser_Data;
wire [1:0] Mux_sel;



Serializer #(Width)  //Serializer
Dut0(
Clk,
Rst,
Ser_en,
Busy,
P_Data, 
Data_Valid,
Ser_Data,
Ser_done
);


parity #(Width)  //Parity
Dut1(
Clk,
Rst,
Parity_En,
Parity_Typ,
Busy, 
P_Data,
Data_Valid,
Parity
);

Mux Dut2  //MUX
(
Clk,
Rst,
Mux_sel,
1'b0, 
Ser_Data,
Parity,
1'b1,
TX_out
);


Fsm Dut3
(
Clk,
Rst,
Data_Valid,
Ser_done,
Parity_En,
Mux_sel,
Busy,
Ser_en
);


endmodule
