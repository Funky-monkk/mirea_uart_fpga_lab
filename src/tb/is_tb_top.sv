module is_tb_top;
import is_pkg_uart_controller::*;

    logic               clk_i;
    logic               rstn_i;
    logic               btn0_i;
    logic               btn1_i;
    logic               uart_data_rx_i;
    
    logic               uart_data_tx_o; 

    is_uart_top dut
    (
        .*
    );

    localparam CLK_PERIOD = 10;


    task reset();
    uart_data_rx_i = '0;
        rstn_i = '1;
        #300;
        rstn_i = '0;
        #300;
        rstn_i = '1;
    endtask

    // task rx_driver()
    


    // endtask

    logic uart_ce;
    
    is_uart_ce uart_m_clk
    (
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        
        .uart_ce_o(uart_ce)
    );


    initial begin
        clk_i = '0;
     forever begin #(CLK_PERIOD/2) clk_i = ~clk_i; end
    end

    initial begin 
         reset();
         #1000;
        @(posedge uart_ce);
        uart_data_rx_i <= '1;
        @(posedge uart_ce);
        uart_data_rx_i <= '0;
        @(posedge uart_ce);
        uart_data_rx_i <= '1;    
      end


endmodule