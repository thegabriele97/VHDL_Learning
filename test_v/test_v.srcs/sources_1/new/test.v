module test(clk, rst, c);
    
    input wire clk;
    input wire rst;
    output reg[3:0] c;
    
    integer init = 0, work = 1;
    reg curr_state, next_state;
    reg[3:0] curr_cnt, next_cnt;
    
    always @(curr_state, curr_cnt) begin
    
        next_state <= curr_state;
        next_cnt <= curr_cnt;
        c <= curr_cnt;
        
        case (curr_state)
        
            init: begin
                next_cnt <= 4'h0;
                next_state <= work;
            end
        
            work: next_cnt <= curr_cnt + 1;
            
            default: next_cnt <= init;
        
        endcase;
    
    end
    
    always @(posedge clk) begin
        if (rst) begin
            curr_state <= init;
            curr_cnt <= 4'h0;
        end
        else begin
            curr_state <= next_state;
            curr_cnt <= next_cnt;
        end
    end

endmodule
