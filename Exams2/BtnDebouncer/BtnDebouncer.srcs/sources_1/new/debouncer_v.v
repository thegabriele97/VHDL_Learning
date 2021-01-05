`timescale 1ns / 1ps

module debouncer_v(clk, rst, bi, bo);
    
    input wire clk;
    input wire rst;
    input wire bi;
    output reg bo;
    
    integer wait_bi = 2'b00,
            bo_on   = 2'b01,
            bo_off  = 2'b11; 
    
    reg[1:0] curr_state, next_state;
    
    always @(curr_state, bi)
    begin
        next_state <= curr_state;
        bo <= 0;
        
        case (curr_state)
            wait_bi: begin
                if (bi)
                    next_state <= bo_on;
            end
            
            bo_on: begin
                bo <= 1;
                next_state <= bo_off;
            end
            
            bo_off: begin
                if (bi == 0)
                    next_state <= wait_bi;
            end
            
        endcase;
    end
    
    always @(posedge clk, rst)
    begin
        if (rst)
            curr_state <= wait_bi;
        else
            curr_state <= next_state;
    end

endmodule
