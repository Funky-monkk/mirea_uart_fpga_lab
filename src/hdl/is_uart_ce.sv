module is_uart_ce 
#(
    parameter BAUDRATE = 2400,
    parameter FREQ = 100_000_000,
    parameter RATIO = 8
)
(
    input  logic clk_i,
    input  logic rstn_i,

    output logic uart_ce_o
);

    localparam DIV_VALUE = (FREQ)/(BAUDRATE * RATIO);

    logic [$clog2(DIV_VALUE)-1:0] cnt;


    always_ff@(posedge clk_i, negedge rstn_i)
        if(~rstn_i) begin
            cnt <= '0;
            uart_ce_o <= '0;
        end
        else if(cnt == (DIV_VALUE -1)) begin
            cnt <= '0;
            uart_ce_o <= '1;
        end
        else begin
            uart_ce_o <= '0;
            cnt <= cnt + 1'b1;
        end

endmodule