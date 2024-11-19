module is_uart_controller
import is_pkg_uart_controller::*;
(
    // Sys
    input  logic clk_i,
    input  logic rstn_i,
    // UART
    input  logic rxd_i,
    output logic txd_o,
    // STP
    output logic rx_data_en_o,
    output logic [9:0] rx_data_t_o,
    // DRP
    input  logic tx_rdy_t_i,
    input  logic [7:0] tx_data_r_i,
    output logic tx_rdy_r_o,    
);
 
//=======================
//--- Local Declarations
//======================= 

    logic rxd_rg;
    logic uart_ce;
    logic rxct_r;
    logic rx_ce;
    logic txct_r;
    logic tx_ce;
//=================
//--- Instances
//=================

    //--- Syncronizer

    is_uart_sync is_uart_sync_controller_inst
    (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .uart_rxd_i(rxd_i),
        .uart_rxd_r_o(rxd_rg),
    );

    //--- UART Clock Div
    is_uart_clk_div is_uart_clk_div_controller_inst
    (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        
        .slow_clk_o(uart_ce)
    );

    //-- Rx FSM
    is_uart_rx_fsm is_uart_rx_fsm_inst
    (
        .rxd_rg_i(rxd_rg),
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .rx_ce_i(rx_ce),
        
        .rx_data_en_o(rx_data_en_o),
        .rxct_r_o(rxct_r),
        .rx_data_t_o(rx_data_t_o)
    );

    //--- Tx FSM
    is_uart_tx_fsm is_uart_tx_fsm_inst
    (
        .clk_i(clk_i)
        .rstn_i(rstn_i),

        .uart_ce_i(uart_ce),
        .tx_ce_i(tx_ce),
        .tx_rdy_t_i(tx_rdy_t_i),
        .tx_data_r_i(tx_data_r_i),
        
        .txd_o(txd_o),
        .tx_rdy_r_o(tx_rdy_r_o),
        .txct_r_o(txct_r)
    );

    //--- Cnt tx 
    is_uart_cnt_samp_tx is_uart_cnt_samp_tx_inst
    (
        .clk_i(clk_i),
        .rstn_i(rstn_i),

        .uart_ce_i(uart_ce),
        .txct_r_i(txct_r),

        .tx_ce_o(tx_ce)
    );

    //--- Cnt rxs
    is_uart_cnt_samp_rx is_uart_cnt_samp_rx_inst
    (
        .clk_i(clk_i),
        .rstn_i(rstn_i),

        .uart_ce_i(uart_ce),
        .rxct_r_i(rxct_r),

        .rx_ce_o(rx_ce)
    );

endmodule