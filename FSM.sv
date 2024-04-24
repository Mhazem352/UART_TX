module FSM #(parameter IN_data =8)(
input wire CLK,RST,
input wire PAR_EN,DATA_VALID,ser_done,
output reg ser_en,BUSY,
output reg [1:0] mux_sel
);



localparam IDLE=3'b000,START=3'b001,
           DATA=3'b010,PARITY=3'b011,
           STOP=3'b100;

reg [2:0]  current_state,next_state;

always@(posedge CLK or negedge RST)
begin
  if(!RST)
    current_state<=IDLE;
  else
    current_state<=next_state;
end

always @(*)
begin
  case(current_state)
        IDLE:begin
              if(DATA_VALID )
                next_state=START;
              else
                next_state=IDLE;
             end 
        START:begin
               next_state=DATA;
              end
        DATA:begin
               if(PAR_EN && ser_done)
                     next_state=PARITY;
               else if(!PAR_EN && ser_done)
                     next_state=STOP;
               else  
                     next_state=DATA;
              end
        PARITY:begin
                next_state=STOP;
               end
        STOP:begin
               next_state=IDLE;
             end
        default: next_state=current_state; 
  endcase             
end

always@(*)
begin
  BUSY=1;
  ser_en=0;
  case(current_state)
    IDLE:begin
          BUSY=1'b0;
          mux_sel='d1;
         end
    START:begin 
          mux_sel='d0;
          end
    DATA:begin
          mux_sel='d2;
          ser_en=1'b1;
         end
    PARITY:begin
          mux_sel='d3;
           end
    STOP:begin
          mux_sel='d1;
         end
    default : begin
               BUSY=1'b1;
               mux_sel='d0;
               ser_en=1'b0;
              end
  endcase
end
endmodule