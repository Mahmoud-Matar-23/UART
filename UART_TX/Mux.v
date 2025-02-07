module Mux

(
 input   wire                  CLK,
 input   wire                  RST,
 input   wire        [1:0]     Mux_sel,
 input   wire                  start, 
 input   wire                  DATA,
 input   wire                  parity,
 input   wire                  Stop,
 output  reg                   Tx_out 
);

reg out;

always@(*) begin

	case(Mux_sel)
		00:  out<=start;
		01:  out<=DATA;
		10:  out<=parity;
		11:  out<=Stop;
	endcase
end

always@(posedge CLK or negedge RST) begin

	if(!RST)
		Tx_out<=0;
	else   
                Tx_out<=out;
end 
endmodule   
