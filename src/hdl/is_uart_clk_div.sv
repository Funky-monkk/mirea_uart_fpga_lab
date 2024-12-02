module is_uart_clk_div
#(
    parameter fast_clk_mhz = 100,
    parameter slow_clk_khz = 1
)
(
    input  logic clk_i,
    input  logic rstn_i,
    
    output logic slow_clk_o
);

    localparam half_period = fast_clk_mhz * 1000_000/(slow_clk_khz * 1000 * 2);
    localparam CNT_W = $clog2(half_period);
    logic slow_clk_raw;
    logic [CNT_W-1 :0] cnt;
    
    
    always_ff@(posedge clk_i, negedge rstn_i) begin
        if(~rstn_i) begin
            cnt <= '0;
            slow_clk_raw <= '0;
        end
        else if(cnt == '0) begin
            cnt <= CNT_W'(half_period-1);
            slow_clk_raw <= ~slow_clk_raw;
            end
        else cnt <= cnt - 1'b1;
    end
    
    BUFG slow_clk_sync (.O(slow_clk_o),.I(slow_clk_raw));

endmodule 