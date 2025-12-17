module datapath(
    input clk, reset,
    input [2:0] money,
    input [1:0] Psel,
    input ldM, check, RC, canceled,
    output  dispense, 
    output error,
    // output reg [3:0] returnChange,
    output [31:0] item_price_flat,  
    output [7:0] total_balance,
    output [7:0] Return_change
);
    // wire [31:0] item_price_flat; // Flattened array  
    // wire [7:0] total_balance;
    // wire [7:0] Return_change;

    // Submodules
    Set_price mod1(clk, reset, item_price_flat);
    totalMoney mod2(clk, reset, ldM, money, total_balance);
    comparator mod3(clk, reset, check, total_balance, item_price_flat, Psel, dispense, error);
    change     mod4(clk, reset, RC, canceled, total_balance, item_price_flat, Psel, Return_change);

    // Assign flattened change to 4-bit returnChange
//    always @(posedge clk or posedge reset) begin
//        if (reset)
//            returnChange <= 0;
//        else
//            returnChange <= Return_change[3:0]; // Take LSB 4 bits
//    end
//endmodule

// =============================
// Set_price: Stores item prices
// =============================
endmodule
module Set_price(
    input clk, reset,
    output reg [31:0] item_price_flat
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            item_price_flat[7:0]   <= 5;   // item_price[0]
            item_price_flat[15:8]  <= 7;   // item_price[1]
            item_price_flat[23:16] <= 8;   // item_price[2]
            item_price_flat[31:24] <= 10;  // item_price[3]
        end
    end
endmodule

// ==================================
// totalMoney: Tracks inserted money
// ==================================   
module totalMoney(
    input clk, reset, ldM,
    input [2:0] money,
    output reg [7:0] total_balance
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            total_balance <= 0;
        else if (ldM)
            total_balance <= total_balance + money;
    end
endmodule 

// =============================================
// comparator: Checks if enough money was added
// =============================================
module comparator(
    input clk, reset, check,
    input [7:0] total_balance,
    input [31:0] item_price_flat,
    input [1:0] Psel,
    output reg dispense,
    output reg error
);
    reg [7:0] selected_price;

    always @(*) begin
        if (reset) begin
            dispense <= 0;
            error <= 0;
        end else if (check) begin
            // Extract selected price from flattened bus
            case (Psel)
                2'b00: selected_price = item_price_flat[7:0];
                2'b01: selected_price = item_price_flat[15:8];
                2'b10: selected_price = item_price_flat[23:16];
                2'b11: selected_price = item_price_flat[31:24];
            endcase

            if (total_balance >= selected_price)
                dispense <= 1;
            else
                error <= 1;
        end
    end
endmodule

// ==========================================
// change: Calculates return/change amount
// ==========================================
module change(
    input clk, reset, RC, canceled,
    input [7:0] total_balance,
    input [31:0] item_price_flat,
    input [1:0] Psel,
    output reg [7:0] Return_change
);
    reg [7:0] selected_price;

    always @(*) begin
        if (reset) begin
            Return_change <= 0;
        end 
        else if (canceled) begin
            Return_change <= total_balance; // Refund total money
        end
        else if (RC) begin
            // Extract selected price from flattened bus
            case (Psel)
                2'b00: selected_price = item_price_flat[7:0];
                2'b01: selected_price = item_price_flat[15:8];
                2'b10: selected_price = item_price_flat[23:16];
                2'b11: selected_price = item_price_flat[31:24];
            endcase
            Return_change <= total_balance - selected_price;
        end 
    end
endmodule