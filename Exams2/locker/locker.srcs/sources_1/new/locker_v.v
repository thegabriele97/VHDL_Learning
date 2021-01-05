`timescale 1ns / 1ps

module locker_v(clk, rst, x, u);
    
    input wire clk;
    input wire rst;
    input wire x;
    output reg u;

    integer a = 3'b000,
            b = 3'b001,
            c = 3'b010,
            d = 3'b011,
            e = 3'b100,
            f = 3'b101;
            
    reg[2:0] curr_state, next_state;
    
    always @(curr_state, x)
    begin
        next_state <= curr_state;
        u <= 0;
        
        case (curr_state)
            a: begin
                if (x == 0) 
                    next_state <= b;
            end
            
            b: begin
                if (x) 
                    next_state <= c;
            end 
            
            c: begin
                next_state <= d;
                if (x) 
                    next_state <= a;
            end
            
            d: begin
                next_state <= e;
                if (x == 0) 
                    next_state <= b;
            end
            
            e: begin
                next_state <= f;
                if (x == 0)
                    next_state <= d;
            end
            
            f: begin
                u <= 1;
                next_state <= b;
                if (x)
                    next_state <= a;                    
            end
        endcase;
    end
    
    always @(posedge clk, rst)
    begin
        if (rst)
            curr_state <= a;
        else
            curr_state <= next_state;
    end

endmodule
