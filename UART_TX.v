module UART_TX #(parameter IN_data =8)(
input wire [IN_data-1:0] P_DATA,
input wire PAR_EN,PAR_TYP,DATA_VALID,
input wire CLK,RST,
output  TX_out,
output BUSY
); 

wire ser_done,ser_en,par_bit,ser_data,start_bit,stop_bit;
wire [1:0] mux_sel;
FSM u0 (
.CLK(CLK),
.RST(RST),
.DATA_VALID(DATA_VALID),
.PAR_EN(PAR_EN),
.ser_done(ser_done),
.ser_en(ser_en),
.mux_sel(mux_sel),
.BUSY(BUSY)
);

Serializer u1 (
.CLK(CLK),
.RST(RST),
.DATA_VALID(DATA_VALID),
.ser_done(ser_done),
.ser_en(ser_en),
.P_DATA(P_DATA),
.ser_data(ser_data),
.BUSY(BUSY)
);

Parity_Calc u2 (
.CLK(CLK),
.RST(RST),
.P_DATA(P_DATA),
.DATA_VALID(DATA_VALID),
.PAR_TYP(PAR_TYP),
.par_bit(par_bit),
.BUSY(BUSY)
);

MUX u3(
.CLK(CLK),
.RST(RST),
.mux_sel(mux_sel),
.ser_data(ser_data),
.par_bit(par_bit),
.TX_out(TX_out)
);
endmodule