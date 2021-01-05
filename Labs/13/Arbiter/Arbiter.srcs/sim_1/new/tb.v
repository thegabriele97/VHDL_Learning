`timescale 1ns / 1ps
module tb();

    reg clk;
    reg rst;
    reg[1:0] req;
    wire[1:0] grant;

    arbiter DUT(clk, rst, req, grant);

    always
    begin
    
        clk <= 1'b0;
        #0.5;
        clk <= 1'b1;
        #0.5;
        
    end    
    
    initial
    begin
    
        rst <= 1;
        #1;
        
        rst <= 0;
        #1;
        
        req <= 2'b01;
        #1;
        
        req <= 2'b11;
        #1;
        
        req <= 2'b10;
        #1;
        
        req <= 2'b11;
        #1;
        
        req <= 2'b01;
        #1;
        
        req <= 2'b00;
    
    end 
    
endmodule
