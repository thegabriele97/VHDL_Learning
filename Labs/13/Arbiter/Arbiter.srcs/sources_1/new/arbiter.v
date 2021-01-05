`timescale 1ns / 1ps

module 

    arbiter(clk, rst, req, grant);
    input wire clk;
    input wire rst;
    input wire[1:0] req;
    output reg[1:0] grant;
    
    parameter wait_req =  0,
              go_grant0 = 1,
              go_grant1 = 2;
    
    reg[2:0] curr_state, next_state;
    
    always @(curr_state, req) begin
        
        next_state <= curr_state;
        grant <= 2'b00;
        
        case (curr_state)
            wait_req: begin
                if (req[0] || (req[0] && req[1]))
                    next_state <= go_grant0;
                else if (req[1])
                    next_state <= go_grant1;                    
            end
            
            go_grant0: begin
                grant[0] <= 1'b1;
                
                if (~req[0]) begin
                    next_state <= wait_req;
                    if (req[1])
                        next_state <= go_grant1;
                end
            end
            
            go_grant1: begin
                grant[1] <= 1'b1;
                
                if (~req[1]) begin
                    next_state <= wait_req;
                    if (req[0])
                        next_state <= go_grant0;
                end
            end
            
        endcase
    end
    
    always @(posedge(clk)) begin
        
        if (rst == 1)
            curr_state <= wait_req;
        else
            curr_state <= next_state;
        
    end

endmodule
