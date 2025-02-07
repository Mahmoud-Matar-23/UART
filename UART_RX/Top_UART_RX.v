module UART_RX #(parameter width=8)
(
input wire   	 	Clk,
input wire   	 	Rst,
input wire    	 	Rx_in,
input wire [5:0] 	Prescale,
input wire    	 	Parity_En,
input wire    	 	Parity_Typ,
output wire [width-1:0] P_Data,
output wire    	 	Data_Valid,
output wire    	 	Parity_Err,
output wire    	 	Framing_Err
);

wire   [3:0]           Bit_count ;
wire   [5:0]           Edge_count ;

wire                   edge_bit_en; 
wire                   Deser_en; 
wire                   Parity_en; 
wire                   Stop_en; 
wire                   Start_en; 
wire                   Start_glitch;
wire                   Sampled_bit;
wire                   dat_samp_en;


De_serializer#(width)
Dut0 (
   	Clk,
   	Rst,
    	Sampled_bit,
    	Deser_en,
 	Prescale,
 	Edge_count,
 	P_Data 
);


Edge_bit_counter 
Dut1(
   	Clk,
   	Rst,
 	edge_bit_en,
 	Prescale,
	Bit_count,
	Edge_count 
);


Data_Sampling
Dut2(
   	Clk,
  	Rst,
    	Rx_in,
    	dat_samp_en,
 	Prescale,
	Edge_count,
 	Sampled_bit 
);


Start_check 
Dut3(
   	Clk,
   	Rst,
    	Sampled_bit,
    	Start_en,
 	Start_glitch 
);


Stop_check 
Dut4(
 	Clk,
	Rst,
	Sampled_bit,
	Stop_en,
	Framing_Err 
);


Parity_check #(width)
Dut5(
 	Clk,
 	Rst,
 	Sampled_bit,
 	Parity_en,
 	Parity_Typ,
 	P_Data,
	Parity_Err 
);


UART_Fsm #(width)
Dut6(
	Clk,
 	Rst,
 	Rx_in,
 	Parity_En,
 	Parity_Err,
 	Start_glitch,
	Framing_Err,
	Prescale,
	Edge_count,
	Bit_count,
 	Deser_en,
 	edge_bit_en,
	Parity_en,
 	Stop_en,
 	Start_en,
	dat_samp_en,
	Data_Valid
);





endmodule
