`timescale 1ns / 1ps

module fsm_v(clk, rst, x, z);
    
    input wire clk;
    input wire rst;
    input wire x;
    output reg z;

    integer a = 0, b = 1, c = 2;
    reg[1:0] curr_state, next_state;

    always @(posedge clk) begin
        if (rst) 
            curr_state <= a;
        else
            curr_state <= next_state;
    end
    
    always @(curr_state, x) 
    begin
        next_state <= curr_state;
        z <= 1'b0;
        
        case (curr_state)
        
            a: if (x) next_state <= b;
            
            b: begin
                next_state <= c;
                if (x == 0) next_state <= a;
            end
        
            c: begin
                z <= 1'b1;
                if (x == 0) next_state <= a;
            end
        
        endcase;
        
    end

endmodule
