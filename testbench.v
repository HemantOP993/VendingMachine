module testbench;

        reg clk;
        reg reset;
        reg [2:0] money;
        reg [1:0] Psel;
        reg cancel;
        reg in;
        
        wire dispense;
        wire start;
        wire done;
        
        wire ldM;
        wire check;
        wire RC;
        wire canceled;
        wire error;
        wire [31:0] item_price_flat;
        wire [7:0] total_balance;
        wire [7:0] Return_change;
        wire [2:0] state;
        
        topmodule mod(clk,reset,money,Psel,cancel,in,dispense,start,done,
                    ldM,check,RC,canceled,error,item_price_flat,
                    total_balance,Return_change,state);
                    
                    
        always #5 clk <= ~clk;
        
        initial begin
                reset=1;clk=0;
                #2 reset=0;
                #1 in=1;
                #3 Psel=1;
                money=2;
                #10 money=5;
                #10 money=1;
                #10 money=1;
                #1 in=0;
                #2 cancel=1;
                
        end
        
        initial #200 $finish;

endmodule