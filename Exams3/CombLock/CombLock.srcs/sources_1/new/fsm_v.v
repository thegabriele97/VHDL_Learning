`timescale 1ns / 1ps

module fsm_v(clk, rst, x, u);

    input wire clk;
    input wire rst;
    input wire x;
    output reg u;
    
    integer a = 0, b = 1, c = 2, d = 3, e = 4, f = 5;
    reg[2:0] curr_state, next_state;
    
    always @(posedge clk, rst) begin
        if (rst == 1) 
            curr_state <= a;
        else
            curr_state <= next_state;
    end
    
    always @(curr_state, x) begin
        
        next_state <= curr_state;
        u <= 1'b0;
        
        case (curr_state)
            
            a: if (x == 0) next_state <= b;
            
            b: if (x) next_state <= c;
            
            c: begin
                next_state <= d;
                if (x) next_state <= a;
            end
            
            d: begin
                next_state <= e;
                if (x == 0) next_state <= b;
            end
            
            e: begin
                next_state <= f;
                if (x == 0) next_state <= d;
            end
            
            f: u <= 1'b1;
            
            default: next_state <= a;
            
        endcase
        
    end

endmodule
