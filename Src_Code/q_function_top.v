`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2020 11:37:23
// Design Name: 
// Module Name: q_function_top
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


module q_function_top(
    input aclk,
    input aresetn,
    input [31:0] X,
    input [31:0] T,
    input [31:0] N,
    input [31:0] alpha,
    input inform_valid,
    output reg [31:0] Q = 0
    );
    reg inform_valid_prev = 0;
    
    always@(posedge aclk)
        inform_valid_prev <= inform_valid;
        
    wire T_ready,X_ready, N_ready, alpha_ready;
    reg T_valid = 0, X_valid = 0, N_valid = 0, alpha_valid = 0;
    
    reg [1:0] count_T_next = 0, count_T_reg = 0;
    reg [1:0] count_X_next = 0, count_X_reg = 0;
    reg [1:0] count_N_next = 0, count_N_reg = 0;
    reg [1:0] count_alpha_next = 0, count_alpha_reg = 0;
    
    always@(posedge aclk)
        begin
            count_T_reg<= count_T_next;
        end
    always@(*)
        begin
            if(T_ready == 1'b1 && T_valid == 1'b1)
                count_T_next = 2;
            else if (count_T_reg ==2)
                count_T_next =3;
        end
        always@(*)
        begin
            if (inform_valid_prev ==0 && inform_valid == 1'b1)
                T_valid = 1;
            else if (count_T_reg ==2)
                T_valid = 0;
         end
         always@(posedge aclk)
         begin
            count_X_reg<= count_X_next;
         end
         always@(*)
         begin
            if(X_ready ==1'b1 && X_valid ==1'b1)
                count_X_next = 2;
            else if(count_X_reg ==2)
                count_X_next =3;
         end
         always@(*)
         begin
            if (inform_valid_prev ==0 && inform_valid == 1'b1)
                         X_valid = 1;
                     else if (count_X_reg ==2)
                         X_valid = 0;
         end
         always@(posedge aclk)
              begin
                 count_N_reg<= count_N_next;
              end
              always@(*)
              begin
                 if(N_ready ==1'b1 && N_valid ==1'b1)
                     count_N_next = 2;
                 else if(count_N_reg ==2)
                     count_N_next =3;
              end
              always@(*)
              begin
                 if (inform_valid_prev ==0 && inform_valid == 1'b1)
                      N_valid = 1;
                  else if (count_N_reg ==2)
                      N_valid = 0;
                  end
                always@(posedge aclk)
                   begin
                      count_alpha_reg<= count_alpha_next;
                   end
                   always@(*)
                   begin
                      if(alpha_ready ==1'b1 && alpha_valid ==1'b1)
                          count_alpha_next = 2;
                      else if(count_alpha_reg ==2)
                          count_alpha_next =3;
                   end
                   always@(*)
                   begin
                      if (inform_valid_prev ==0 && inform_valid == 1'b1)
                                   alpha_valid = 1;
                               else if (count_alpha_reg ==2)
                                   alpha_valid = 0;
                    end  
                wire [31:0] Q_int;
                wire Q_int_valid;
                q_function_calc u1(
                    .aclk(aclk),
                    .aresetn(aresetn),
                    .N(N),
                    .X(X),
                    .T(T),
                    .alpha(alpha),
                    .alpha_valid(alpha_valid),
                    .Q(Q_int),
                    .N_valid(N_valid),
                    .X_valid(X_valid),
                    .T_valid(T_valid),
                    .Q_valid(Q_int_valid),
                    .N_ready(N_ready),
                    .X_ready(X_ready),
                    .T_ready(T_ready),
                    .alpha_ready(alpha_ready)
                    );
                    always@(posedge aclk)
                        if(Q_int_valid)
                        Q <= Q_int;
                        
                endmodule
