module is_uart_rx_fsm
import is_pkg_uart_controller::*;
(
    input  logic rxd_rg_i,
    input  logic clk_i,
    input  logic rstn_i,
    input  logic rx_ce_i,
    
    output logic rx_data_en_o,
    output logic rxct_r_o,
    output logic [9:0] rx_data_t_o
);

//====================== 
//--- Local Declaratons
//======================

    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        RSTRB = 3'b001,
        RDT   = 3'b010,
        RPARB = 3'b011,
        RSTB1 = 3'b100,
        RSTB2 = 3'b101,
        WEND  = 3'b110,
        XXX   = 'x } state_r;

    state_r state;

    logic [2:0] rx_data_cnt;

//=====================

    always_ff@(posedge clk_i, negedge rstn_i) begin
        if(rstn_i) begin
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
                if(rx_ce_i)
                    if(rxd_rg_i) begin
                        rxct_r_o <= '1;
                        state <= IDLE;
                    end
                    else state <= RDT;
                else state <= RSTRB;
            end
            
            RDT: begin
                if(rx_ce_i) begin
                    rx_data_t_o <= {rxd_rg_i,rx_data_t_o[7:1]};
                    rx_data_cnt <= rx_data_cnt + 1'b1;
                    if(rx_data_cnt == 4'h7) state <= RPARB;
                    else state <= RDT;
                end
                else state <= RDT;
            end
            RPARB: begin
                if(rx_ce_i) begin
                    rx_data_t_o[8] <= (rxd_rg_i == '0); // Space 
                    state <= RSTB1;
                end
                else state <= RPARB; 
            end
            
            RSTB1: begin
                if(rx_ce_i) begin
                    rx_data_t_o[9] <= ~rxd_rg_i;
                    state <= RSTB2;
                end
                else state <= RSTB1;
            end
            RSTB2: begin
                if(rx_ce_i) 
                    if(rxd_rg_i) begin
                        state <= IDLE;
                        rx_data_en_o <= '1;
                        rxct_r_o <= '1;
                    end
                    else state <= WEND;
                else state <= RSTB2;
            end
        //     WEND:begin 
        //         if(rxd_rg_i) begin
        //             state <= IDLE;
        //             rx_data_en_o <= '1;
        //             rxct_r_o <= '1;  
        //         end  
        //         else state <= WEND:
        //     end 
        // default: state <= IDLE;  
            WEND:begin 
                    state <= IDLE;
                    rx_data_en_o <= '1;
                    rxct_r_o <= '1;  
                end
        default: state <= IDLE;        
        endcase
    end

endmodule