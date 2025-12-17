module Controller(
        input clk,reset,
        input in,
        input cancel,error,
        output reg ldM,check,RC,canceled,
        output reg start,done,
        output reg [2:0] state);
        
        parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5;
        // reg [2:0] state;
        
        
         always @(*) begin
                start = 0 ; ldM =0;check =0;RC =0;canceled =0;done =0;
                case(state) 
                    S0: start = 1;
                    S1: ldM = 1;
                    S2: check =1;
                    S3: RC =1;
                    S4: canceled =1;
                    S5: done =1;
                endcase
         end
         
         always @(posedge clk or posedge reset) begin
         
                    if(reset) begin
                        state <= S0;
                    end
                    else begin
                        case(state) 
                            S0: state <= in ? S1:S0;  // ideal state 
                            S1: state <= in ? S1:S2;  // coin accepts and sel product
                            S2: begin
                                    if(cancel || error) begin
                                           state <= S4;
                                    end
                                    else 
                                           state <= S3;
                            end
                            S3: state <= S5;
                            S4: state <= S5;
                            S5: state <= S5;
                            default : state <= S0;
                        endcase
                   end
         end
endmodule