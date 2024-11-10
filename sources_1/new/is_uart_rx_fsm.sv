module is_uart_rx_fsm
import is_pkg_uart_controller::*;
(
    input  logic rxd_rg_i,
    input  logic clk_i,
    input  logic rst_i,
    input  logic rx_ce_i,
    
    output logic rx_data_en_o,
    output logic rxct_r_o,
    output logic [9:0] rx_data_t_o
);

//====================== 
//--- Local Declaratons
//======================

    state_r state;

    logic [2:0] rx_data_cnt;

//=====================

    always_ff@(posedge clk_i, negedge rst_i) begin
        if(rst_i) begin
            state <= IDLE;
            rx_data_en_o <= '0;
            rx_data_t_o <= '0;
            rxct_r_o <= '1;
            rx_data_cnt <= '0;
        end
        else case(state)
            IDLE: begin
                if(~rxd_rg_i) begin
                    state <= RSTRB;
                    rx_data_en_o <= '0;
                    rx_data_t_o[9] <= '0;
                    rxct_r_o <= '0;
                end
                else begin
                    state <= IDLE;
                    rx_data_en_o <= '0;
                end
            end        
            RSTRB: begin
            end
            
            RDT:
            RPARB:
            RSTB1:
            RSTB2:
            WEND:             
        endcase
    end

endmodule