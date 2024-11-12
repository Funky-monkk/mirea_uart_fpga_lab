module is_uart_tx_fsm
import is_pkg_uart_controller::*;
(
    input  logic clk_i,
    input  logic rst_i,

    input  logic uart_ce_i,
    input  logic tx_ce_i,
    input  logic tx_rdy_t_i,
    input  logic [DATA_W-1 :0] tx_data_r_i,
    
    output logic txd_o,
    output logic tx_rdy_r_o,
    output logic txct_r_o
);



//====================== 
//--- Local Declaratons
//======================

state_t state;

logic [2:0] tx_data_cnt;
logic tx_par_bit_r;
logic [DATA_W-1 :0] tx_data;
//=====================

always_ff@(posedge clk_i, negedge rst_i) begin
    if(rst_i) begin
        state <= IDLE;
        tx_data <= '0;
        tx_par_bit_r <= '0;
        tx_rdy_r_o  <= '0;
        tx_data_cnt  <= '0;
        txd_o    <= '1;
        txct_r_o <= '1;
    end
    else case(state)
        IDLE: begin
            if(tx_rdy_t_i) begin
                tx_data <= tx_data_r_i;
                tx_par_bit_r <= '0;
                tx_rdy_r <= '0;
                if(uart_ce_i) begin
                    txd_o <= '0;
                    txct_r_o <= '0;
                    state <= TSTRB;
                end
                else state <= WCE;
            end
            else begin
                state <= IDLE;
                rx_data_en_o <= '0;
            end
        end 
        WCE:  
            if(uart_ce_i) begin
                txd_o <= '0;
                txct_r_o <= '0;
                state <= TSTRB;
            end    
            else state <= WCE;
        TSTRB:
            if(tx_ce_i) begin
                txd_o <= tx_data[0];
                tx_data <= {1'b0,tx_data[7:1]};
                else state <= TDT;
            end
            else state <= TSTRB;

        TDT:
            if(tx_ce_i) begin
                tx_data <= {1'b0,tx_data[7:1]};
                tx_data_cnt <= tx_data_cnt + 1'b1;
                if(tx_data_cnt == 4'h7) begin 
                    txd_o <= tx_par_bit_r;
                    state <= TPARB;
                end
                else begin
                    state <= TDT;
                    txd_o <= tx_data[0];
                end 
            end
            else state <= RDT;

        TPARB: begin
            if(tx_ce_i) begin
                txd_o <= '1;
                state <= TSTB1;
            end
            else state <= TPARB; 
        end
        
        TSTB1: begin
            if(tx_ce_i) begin
                txd_o <= '1;
                state <= TSTB2;
            end
            else state <= TSTB1;
        end
        TSTB2: begin
            if(tx_ce_i) 
                tx_rdy_r_o <= '1
                txct_r_o <= '1
                state <= IDLE;
            else state <= TSTB2;
        end
    default: state <= IDLE;         
    endcase
end



endmodule