`timescale 1us/1ps
module UART_TX_tb();
parameter IN_data =8;
localparam T=8.68; //115.2 KHz

 wire TX_out_tb,BUSY_tb;
 reg CLK_tb,RST_tb;
 reg [IN_data-1:0] P_DATA_tb;
 reg PAR_EN_tb,PAR_TYP_tb,DATA_VALID_tb;

UART_TX DUT (
.CLK(CLK_tb),
.RST(RST_tb),
.P_DATA(P_DATA_tb),
.PAR_EN(PAR_EN_tb),
.PAR_TYP(PAR_TYP_tb),
.DATA_VALID(DATA_VALID_tb),
.TX_out(TX_out_tb),
.BUSY(BUSY_tb)
);

initial
begin
initialize;
reset;
repeat(2)@(negedge CLK_tb);
parity_check(8'hd8); 
check_out(8'hd8);
@(negedge BUSY_tb)
repeat(5)@(negedge CLK_tb);
parity_odd(8'hdf);
check_out(8'hdf);
@(negedge BUSY_tb)
repeat(5)@(negedge CLK_tb);
parity_even(8'hac);   
check_out(8'hac);
@(negedge BUSY_tb)
repeat(5)@(negedge CLK_tb);
$stop;
end





//CLK gen
always 
begin
  CLK_tb=0;
  #(T/2);
  CLK_tb=1;
  #(T/2);
end


//Reset task
task reset;
  begin
    RST_tb=0;
    #2;
    RST_tb=1;
  end
endtask


//initialize task
task initialize;
  begin
    PAR_EN_tb=0;
    PAR_TYP_tb=0;
    DATA_VALID_tb=0;
  end 
endtask


task parity_check;
  input [IN_data-1:0] data;
  begin
    P_DATA_tb=data;
    DATA_VALID_tb=1;
    PAR_EN_tb=0;
    PAR_TYP_tb=0;
    $display("contain no parity");
  end
endtask

task parity_even;
  input [IN_data-1:0] data;
  begin
    P_DATA_tb=data;
    DATA_VALID_tb=1;
    PAR_EN_tb=1;
    PAR_TYP_tb=0;
    $display("contain even parity");
  end
endtask

task parity_odd;
  input [IN_data-1:0] data;
  begin
    P_DATA_tb=data;
    DATA_VALID_tb=1;
    PAR_EN_tb=1;
    PAR_TYP_tb=1;
    $display("contain odd parity");
  end
endtask


//output check task
task check_out;
input [IN_data-1:0]expec_out;
reg [IN_data-1:0]gener_out;
integer i;
begin
    @(posedge BUSY_tb)
    #((3*T)/2) ; // to sample at the middle of the bit period 
    DATA_VALID_tb=0;  
    for(i=0;i<IN_data;i=i+1)begin
        gener_out[i]=TX_out_tb; 
        #(T); 
    end  
    if(gener_out==expec_out)
    $display("Test Case is succeeded");
    else
    $display("Test Case  is failed");
    gener_out=0;
end
endtask

endmodule