module is_uart_sync
(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic uart_rxd_i,
    
    output logic uart_rxd_r_o
);

    logic [1:0] rx_ff;
    
    always_ff@(posedge clk_i, negedge rstn_i) begin
        if(~rstn_i) begin
            uart_rxd_r_o <= '1;
            rx_ff <= '1;
        end
        else begin
            rx_ff[0] <= uart_rxd_i;
            rx_ff[1] <= rx_ff[0];
            uart_rxd_r_o <= rx_ff[1];
        end
    end

endmodule
