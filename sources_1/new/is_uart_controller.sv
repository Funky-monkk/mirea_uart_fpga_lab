module is_uart_controller
(
    // Sys
    input  logic clk_i,
    input  logic rst_i,
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
 


//=================
//--- Instances
//=================

    //--- Syncronizer

    is_uart_sync is_uart_sync_controller_inst
    (
        .clk_i(),
        .rst_i(),
        .uart_rxd_i(),
        .uart_rxd_r_o(),
    );

    // UART Clock Div
    is_uart_clk_div is_uart_clk_div_controller_inst
    (
        .clk_i(),
        .rst_i(),
        
        .slow_clk_o()
    );

endmodule