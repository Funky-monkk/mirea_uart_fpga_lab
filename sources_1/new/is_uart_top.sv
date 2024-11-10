module is_uart_top
import is_pkg_uart_controller::*;
(
    input  logic               clk_i,
    input  logic               rstn_i,
    input  logic               btn0_i,
    input  logic               btn1_i,
    input  logic [DATA_W-1 :0] uart_data_rx_i,
    
    output logic [DATA_W-1 :0] uart_data_tx_o    
);
    
//=======================
//--- Local Declarations
//=======================
    logic sync_rstn;
    logic slow_clk;
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
        .RST(sync_rstn),                     
        .BTN_OUT(),                
        .BTN_CEO()                  
    );

 M_BTN_FILTER_V10 btn_1_debounce_inst
    (
        .CLK(clk_i),                    
        .CE(slow_clk),                     
        .BTN_IN(btn1_i),                 
        .RST(sync_rstn),                     
        .BTN_OUT(),                
        .BTN_CEO()                  
    );

//---

//--- Clock Divider

    is_uart_clk_div 
    #(
        .fast_clk_mhz(),
        .slow_clk_khz()
    )
    clk_div_inst
    (
        .clk_i(clk_i),
        .rst_i(sync_rstn),
        
        .slow_clk_o(slow_clk)
    );
//---
endmodule