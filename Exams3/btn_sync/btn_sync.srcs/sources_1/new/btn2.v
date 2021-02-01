module btn2(clk, rst, bi, bo);
    
    input wire clk;
    input wire rst;
    input wire bi;
    output reg bo;

    integer wait_bi = 0,
            bon     = 1,
            boff    = 2;

    reg[1:0] curr_state, next_state;
    
    always @(posedge clk) begin
        
        if (rst)
            curr_state <= wait_bi;
        else
            curr_state <= next_state;
        
    end

    always @(curr_state, bi) begin
        
        next_state <= curr_state;
        bo <= 1'b0;
        
        case (curr_state)
        
            wait_bi: begin
                if (bi)
                    next_state <= bon;
            end
        
            bon: begin
                bo <= 1'b1;
                next_state <= boff;
            end
        
            boff: begin
                if (bi == 0)
                    next_state <= wait_bi;
            end            
        
        endcase
        
    end

endmodule
