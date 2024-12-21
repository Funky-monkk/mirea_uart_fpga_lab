module is_uart_cnt_samp_tx
import is_pkg_uart_controller::*;
(
    input  logic clk_i,
    input  logic rstn_i,

    input  logic uart_ce_i,
    input  logic txct_r_i,

    output logic tx_ce_o
);


    logic [$clog2(RATIO)-1 :0] cnt_sample;


    always_ff@(posedge clk_i, negedge rstn_i) begin
        if(~rstn_i || txct_r_i) cnt_sample <= '0;
        else if (uart_ce_i) cnt_sample <= cnt_sample + 1'b1;
    end

    assign tx_ce_o = uart_ce_i && cnt_sample[2] && 
                         cnt_sample[1] && cnt_sample[0];


endmodule
