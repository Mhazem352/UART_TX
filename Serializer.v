module Serializer #(parameter IN_data =8,
                              count_bit=3)(
input wire CLK,RST,
input wire ser_en,DATA_VALID,BUSY,
input wire [IN_data-1:0] P_DATA,
output  ser_done,ser_data
);


reg [count_bit-1:0] counter;
reg [IN_data-1:0]   SR; //shift register
assign ser_done=&counter;
assign ser_data=SR[0];

always @(posedge CLK or negedge RST)
begin
  if(!RST) begin
    counter<=0;
    SR<='d0;
  end
  else if(DATA_VALID && (!BUSY) )
      begin
        SR<=P_DATA;
        end
  else if(ser_en && !ser_done)
    begin
      SR<= {1'b0,SR[IN_data-1:1]};
      end
end

always@(posedge CLK or negedge RST)
begin
  if(!RST)
        counter<=0;
  else if(!ser_done && ser_en)
    counter<=counter+1;
  else
    counter<=0;
end

endmodule