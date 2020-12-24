`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2020 23:20:29
// Design Name: 
// Module Name: Tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Tb(

    );
    reg aclk = 0;
    always#5 aclk =~aclk;
    reg inform_valid = 0,aresetn =0;
    reg [31:0] X=0,T=0, N=0,alpha=0;
    wire[31:0] Q;
    
    q_function_top u1(
    aclk,
    aresetn,
    X,
    T,
    N,
    alpha,
    inform_valid,
    Q
    );
    initial
    begin
        #100 aresetn =1;
        #20 X = 8'd32;
            T = 8'd55;
            N = 8'd101;
            alpha = 8'd2;
            inform_valid =1;
         #20 inform_valid = 0;
         #300 $stop;
        end  
endmodule
