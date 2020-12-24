`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2020 11:12:55
// Design Name: 
// Module Name: q_function_calc
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


module q_function_calc(
    input aclk,
    input aresetn,
    input [31:0] N,
    input [31:0] X,
    input [31:0] T,
    input [31:0] alpha,
    input alpha_valid,
    output [31:0] Q,
    input N_valid,
    input X_valid,
    input T_valid,
    output Q_valid,
    output N_ready,
    output X_ready,
    output T_ready,
    output alpha_ready
    );
    wire [31:0] FN;
    wire FN_ready, FN_valid;
    
    fixed_to_float N_Float(
      .aclk(aclk),                                  // input wire aclk
      .aresetn(aresetn),                            // input wire aresetn
      .s_axis_a_tvalid(N_valid),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(N_ready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(N),              // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(FN_valid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready(FN_ready),  // input wire m_axis_result_tready
      .m_axis_result_tdata(FN)    // output wire [31 : 0] m_axis_result_tdata
    );
      wire [31:0] Falpha;
      wire Falpha_ready, Falpha_valid;
        
        fixed_to_float alpha_Float(
          .aclk(aclk),                                  // input wire aclk
          .aresetn(aresetn),                            // input wire aresetn
          .s_axis_a_tvalid(alpha_valid),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(alpha_ready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(alpha),              // input wire [31 : 0] s_axis_a_tdata
          .m_axis_result_tvalid(Falpha_valid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(Falpha_ready),  // input wire m_axis_result_tready
          .m_axis_result_tdata(Falpha)    // output wire [31 : 0] m_axis_result_tdata
        );  
      wire [31:0] FT;
      wire FT_ready, FT_valid;
      
      fixed_to_float T_Float(
        .aclk(aclk),                                  // input wire aclk
        .aresetn(aresetn),                            // input wire aresetn
        .s_axis_a_tvalid(T_valid),            // input wire s_axis_a_tvalid
        .s_axis_a_tready(T_ready),            // output wire s_axis_a_tready
        .s_axis_a_tdata(T),              // input wire [31 : 0] s_axis_a_tdata
        .m_axis_result_tvalid(FT_valid),  // output wire m_axis_result_tvalid
        .m_axis_result_tready(FT_ready),  // input wire m_axis_result_tready
        .m_axis_result_tdata(FT)    // output wire [31 : 0] m_axis_result_tdata
      );
        wire [31:0] FX;
        wire FX_ready, FX_valid;
        
        fixed_to_float X_Float(
          .aclk(aclk),                          //input wire aclk
          .aresetn(aresetn),                    // input wire aresetn
          .s_axis_a_tvalid(X_valid),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(X_ready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(X),                   // input wire [31 : 0] s_axis_a_tdata
          .m_axis_result_tvalid(FX_valid),      // output wire m_axis_result_tvalid
          .m_axis_result_tready(FX_ready),      // input wire m_axis_result_tready
          .m_axis_result_tdata(FX)              // output wire [31 : 0] m_axis_result_tdata
        );
        wire[31:0] ln_N;
        wire ln_N_ready,ln_N_valid;
        logarithm lnN (
          .aclk(aclk),                                  // input wire aclk
          .aresetn(aresetn),                            // input wire aresetn
          .s_axis_a_tvalid(FN_valid),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(FN_ready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(FN),              // input wire [31 : 0] s_axis_a_tdata
          .m_axis_result_tvalid(ln_N_valid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(ln_N_ready),  // input wire m_axis_result_tready
          .m_axis_result_tdata(ln_N)    // output wire [31 : 0] m_axis_result_tdata
        );
        wire [31:0] ln_N_div_T;
        wire ln_N_div_T_ready,ln_N_div_T_valid;
        divide lnN_div_T (
          .aclk(aclk),                                  // input wire aclk
          .aresetn(aresetn),                            // input wire aresetn
          .s_axis_a_tvalid(ln_N_valid),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(ln_N_ready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(ln_N),              // input wire [31 : 0] s_axis_a_tdata
          .s_axis_b_tvalid(FT_valid),            // input wire s_axis_b_tvalid
          //.s_axis_b_tready(FT_ready),            // output wire s_axis_b_tready
          .s_axis_b_tdata(FT),              // input wire [31 : 0] s_axis_b_tdata
          .m_axis_result_tvalid(ln_N_div_T_valid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(ln_N_div_T_ready),  // input wire m_axis_result_tready
          .m_axis_result_tdata(ln_N_div_T)    // output wire [31 : 0] m_axis_result_tdata
        );
        wire[31:0] product;
        wire product_ready,product_valid;
        multiply alpha_x_log (
          .aclk(aclk),                                  // input wire aclk
          .aresetn(aresetn),                            // input wire aresetn
          .s_axis_a_tvalid(Falpha_valid),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(Falpha_ready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(Falpha),              // input wire [31 : 0] s_axis_a_tdata
          .s_axis_b_tvalid(ln_N_div_T_valid),            // input wire s_axis_b_tvalid
          .s_axis_b_tready(ln_N_div_T_ready),            // output wire s_axis_b_tready
          .s_axis_b_tdata(ln_N_div_T),              // input wire [31 : 0] s_axis_b_tdata
          .m_axis_result_tvalid(product_valid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(product_ready),  // input wire m_axis_result_tready
          .m_axis_result_tdata(product)    // output wire [31 : 0] m_axis_result_tdata
        );
        wire [31:0] root;
        wire root_ready,root_valid;
        square_root sqrt (
          .aclk(aclk),                                  // input wire aclk
          .aresetn(aresetn),                            // input wire aresetn
          .s_axis_a_tvalid(product_valid),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(product_ready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(product),              // input wire [31 : 0] s_axis_a_tdata
          .m_axis_result_tvalid(root_valid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(root_ready),  // input wire m_axis_result_tready
          .m_axis_result_tdata(root)    // output wire [31 : 0] m_axis_result_tdata
        );
        wire [31:0] X_div_T;
        wire X_div_T_ready,X_div_T_valid;
        divide x_div_T (
                  .aclk(aclk),                                  // input wire aclk
                  .aresetn(aresetn),                            // input wire aresetn
                  .s_axis_a_tvalid(FX_valid),            // input wire s_axis_a_tvalid
                  .s_axis_a_tready(FX_ready),            // output wire s_axis_a_tready
                  .s_axis_a_tdata(FX),              // input wire [31 : 0] s_axis_a_tdata
                  .s_axis_b_tvalid(FT_valid),            // input wire s_axis_b_tvalid
                  //.s_axis_b_tready(FT_ready),            // output wire s_axis_b_tready
                  .s_axis_b_tdata(FT),              // input wire [31 : 0] s_axis_b_tdata
                  .m_axis_result_tvalid(X_div_T_valid),  // output wire m_axis_result_tvalid
                  .m_axis_result_tready(X_div_T_ready),  // input wire m_axis_result_tready
                  .m_axis_result_tdata(X_div_T)    // output wire [31 : 0] m_axis_result_tdata
                );
        addition result (
                  .aclk(aclk),                                        // input wire aclk
                  .aresetn(aresetn),                                  // input wire aresetn
                  .s_axis_a_tvalid(X_div_T_valid),                  // input wire s_axis_a_tvalid
                  .s_axis_a_tready(X_div_T_ready),                  // output wire s_axis_a_tready
                  .s_axis_a_tdata(X_div_T),                    // input wire [31 : 0] s_axis_a_tdata
                  .s_axis_b_tvalid(root_valid),                  // input wire s_axis_b_tvalid
                  .s_axis_b_tready(root_ready),                  // output wire s_axis_b_tready
                  .s_axis_b_tdata(root),                    // input wire [31 : 0] s_axis_b_tdata
                  .m_axis_result_tvalid(Q_valid),        // output wire m_axis_result_tvalid
                  .m_axis_result_tready(1'b1),        // input wire m_axis_result_tready
                  .m_axis_result_tdata(Q)          // output wire [31 : 0] m_axis_result_tdata
                );
endmodule
