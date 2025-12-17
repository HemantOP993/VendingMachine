module topmodule(
        input clk,reset,
        input [2:0] money,
        input [1:0] Psel,
        input cancel,in,
        output  dispense,
        // output reg [3:0] Return_change,
        output  start,done,
        output ldM,check,RC,canceled,error,
        output [31:0] item_price_flat,
        output [7:0] total_balance,
        output [7:0] Return_change,
        output [2:0] state);
        
        
        datapath mod1(clk,reset,money,Psel,ldM,check,RC,canceled,dispense,error,item_price_flat,total_balance,Return_change);
        Controller mod2(clk,reset,in,cancel,error,ldM,check,RC,canceled,start,done,state);
        
        
endmodule