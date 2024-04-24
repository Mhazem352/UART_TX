module MUX (
input wire CLK ,RST,
input wire ser_data,par_bit,
input wire [1:0] mux_sel,
output reg TX_out
);

always @(*)
    begin
      case(mux_sel)
        2'b00:TX_out=1'b0;
        2'b01:TX_out=1'b1;
        2'b10:TX_out=ser_data;
        2'b11:TX_out=par_bit;
       endcase
    end
endmodule