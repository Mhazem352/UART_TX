module Parity_Calc #(parameter IN_data =8)(
input wire CLK,RST,
input wire DATA_VALID,BUSY,
input wire [IN_data-1:0] P_DATA,
input wire PAR_TYP,
output reg par_bit
);
always@(posedge CLK or negedge RST)
begin
 if(!RST)
     par_bit<=0;
 else begin
     case({DATA_VALID,BUSY,PAR_TYP})
       'b100:par_bit<=^P_DATA;
       'b101:par_bit<=~^P_DATA;
       default:par_bit<=par_bit; 
     endcase
    end
end
endmodule