`timescale 1ns / 1ps

module bcd_v(clk, rst, x, z);
    
    input wire clk;
    input wire rst;
    input wire x;
    output reg z;
    
    integer C = 0, D = 1, E = 2, F = 3, G = 4;
    reg[2:0] curr_state, next_state;
    
    always @(posedge(clk)) begin
        if (rst) curr_state <= C;
        else curr_state <= next_state;
    end
    
    always @(curr_state, x) begin
    
        next_state <= curr_state;
        z <= 1'b0;
        
        case(curr_state)
        
            C: begin
                next_state <= D;
                if (x) next_state <= E;
            end
            
            D: begin
                next_state <= G;
                if (x) begin
                    z <= 1'b1;
                    next_state <= F;
                end
            end
        
            E: begin
                next_state <= D;
                if (x) begin
                    z <= 1'b1;
                    next_state <= F;
                end
            end
        
            F: begin
                if (x) z <= 1'b1;
                else next_state <= D;
            end
            
            G: begin
                if (x) next_state <= E;
            end
            
            default: next_state <= C;
        
        endcase;
    
    end

endmodule
