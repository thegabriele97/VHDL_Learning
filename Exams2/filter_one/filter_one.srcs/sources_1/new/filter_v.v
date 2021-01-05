`timescale 1ns / 1ps

module filter_v(clk, rst, x, z);

    input wire clk;
    input wire rst;
    input wire x;
    output reg z;

    integer a = 2'b00,
            b = 2'b01,
            c = 2'b10,
            d = 2'b11;
            
    reg[1:0] curr_state, next_state;
    
    always @(curr_state, x)
    begin
        next_state <= curr_state;
        z <= 0;
        
        case (curr_state)
            a: begin
                if (x)
                    next_state <= b;
                else
                    next_state <= d;
            end
            
            b: begin    
                if (x)
                    next_state <= c;
                else
                    next_state <= d;
            end
            
            c: begin
                z <= 1;
                
                if (x == 0)
                    next_state <= d;
            end        
            
            d: begin
                if (x)
                    next_state <= b;
            end                
        endcase
    end
    
    always @(posedge clk, rst)
    begin
        if (rst) 
            curr_state <= a;
        else
            curr_state <= next_state;
    end

endmodule
