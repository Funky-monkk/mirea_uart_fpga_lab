module is_uart_top
import is_pkg_uart_controller::*;
(
    input  logic               clk_i,
    input  logic               rstn_i,
    input  logic               btn0_i,
    input  logic               btn1_i,
    input  logic               uart_data_rx_i,
    
    output logic               uart_data_tx_o    
);
    
//=======================
//--- Local Declarations
//=======================
    logic sync_rstn;
    logic slow_clk;

    logic gen_frt_err;
    logic gen_par_err;

    logic [9:0] rx_data_t;
    logic [9:0] data_with_err;
    logic rx_data_en;
    logic [DATA_W-1 :0] tx_data_r;
    logic tx_rdy_t;
    logic tx_rdy_r;
    logic hex_flg;
    logic [3:0] dc_hex_data;
    logic [DATA_W-1 :0] ascii_data;
    logic [DATA_W-1 :0] dc_ascii_data;
    logic [3:0] hex_data;
    logic [DATA_W-1 :0] rom_data;
    logic [MEM_WIDTH-1 :0] rom_addr;
//========================


//=========================
//--- Instances
//=========================

//--- Async Reset Sync Output
    is_arst_sync arst_sync_inst
    (
        .clk_i(clk_i),
        .a_rstn_i(rstn_i),

        .sync_rstn_o(sync_rstn)
    );
 //---
 
//--- Debounce filter for two buttons

 M_BTN_FILTER_V10 btn_0_debounce_inst
    (
        .CLK(clk_i),                    
        .CE(slow_clk),                     
        .BTN_IN(btn0_i),                 
        .RST(~sync_rstn),                     
        .BTN_OUT(gen_frt_err),                
        .BTN_CEO()                  
    );

 M_BTN_FILTER_V10 btn_1_debounce_inst
    (
        .CLK(clk_i),                    
        .CE(slow_clk),                     
        .BTN_IN(btn1_i),                 
        .RST(~sync_rstn),                     
        .BTN_OUT(gen_par_err),                
        .BTN_CEO()                  
    );

//---

//--- Clock Divider

    is_uart_clk_div 
    #(
        .fast_clk_mhz(100),
        .slow_clk_khz(1)
    )
    clk_div_inst
    (
        .clk_i(clk_i),
        .rstn_i(sync_rstn),
        
        .slow_clk_o(slow_clk)
    );
//---

//--- UART Controller

    is_uart_controller is_uart_controller_inst
    (
        .clk_i(clk_i),
        .rstn_i(sync_rstn),

        .rxd_i(uart_data_rx_i),
        .txd_o(uart_data_tx_o),

        .rx_data_en_o(rx_data_en),
        .rx_data_t_o(rx_data_t),

        .tx_rdy_t_i(tx_rdy_t),
        .tx_data_r_i(tx_data_r),
        .tx_rdy_r_o(tx_rdy_r)  
    );

//---

//--- Comb Error Generation

    is_uart_err_gen is_uart_err_gen_inst
    (
        .rx_data_t_i(rx_data_t),
        .gen_frt_err_i(gen_frt_err),
        .gen_par_err_i(gen_par_err),

        .data_o(data_with_err)
    );

//---

//--- Main FSM

    is_fsm is_fsm_inst
    (
    .clk_i(clk_i),
    .rstn_i(sync_rstn),

    .rx_data_en_i(rx_data_en),
    .rx_data_r_i(data_with_err),

    .tx_rdy_r_i(tx_rdy_r),
    .tx_rdy_t_o(tx_rdy_t),
    .tx_data_t_o(tx_data_r),

    .hex_flg_i(hex_flg),
    .dc_hex_data_i(dc_hex_data),
    .ascii_data_o(ascii_data),

    .dc_ascii_data_i(dc_ascii_data),
    .hex_data_o(hex_data),

    .data_i(rom_data),
    .addr_o(rom_addr)
    );

//---

//--- ROM

    is_uart_rom is_uart_rom_inst
    (
        .rom_addr_i(rom_addr),
        
        .rom_data_o(rom_data)
    );

//---

//--- Decoders for ASCII and HEX

    is_uart_dec_hex_ascii is_uart_dec_hex_ascii_inst
    (
        .hex_data_i(hex_data),
        
        .ascii_data_o(dc_ascii_data)
    );

    is_uart_dec_ascii_hex is_uart_dec_ascii_hex_inst
    (
        .ascii_data_i(ascii_data),
        
        .hex_data_o(dc_hex_data),
        .hex_flg_o(hex_flg)
    );

//---

//======================

endmodule