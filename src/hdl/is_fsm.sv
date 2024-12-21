module is_fsm 
import is_pkg_uart_controller::*;
(

    input  logic clk_i,
    input  logic rstn_i,

    input  logic rx_data_en_i,
    input  logic [9:0] rx_data_r_i,

    input  logic tx_rdy_r_i,
    output logic tx_rdy_t_o,
    output logic [DATA_W-1 :0] tx_data_t_o,

    input  logic  hex_flg_i,
    input  logic [3:0] dc_hex_data_i,
    output logic [DATA_W-1:0] ascii_data_o,

    input  logic [DATA_W-1 :0] dc_ascii_data_i,
    output logic [3:0]         hex_data_o,

    input  logic [DATA_W-1 :0] data_i,
    output logic [MEM_WIDTH-1 :0] addr_o
);

    typedef enum logic [3:0] {
        IDLE = 4'b0000,
        RDT  = 4'b0001,
        RCR  = 4'b0010,
        RLF  = 4'b0011,
        TRES = 4'b0100,
        TMEM = 4'b0101,
        TDT  = 4'b0110,
        TCR  = 4'b0111,
        TLF  = 4'b1000 } state_f;

    state_f state;

    logic [$clog2(DATA_RX_W)-1 :0] data_cnt;
    logic [$clog2(DATA_TX_W)-1 :0] res_cnt;
    logic [DATA_TX_W-1 :0] res_reg;
    logic [DATA_RX_W-1 :0] data_reg;
    logic [MEM_WIDTH-1 :0] end_addr;
    logic res_flg;
    logic [MEM_WIDTH-1 :0] ERR_A0_MX;
    logic [MEM_WIDTH-1 :0] ERR_A1_MX;
    logic [MEM_WIDTH-1 :0] RES_A0;
    logic [MEM_WIDTH-1 :0] RES_A1;  

    always_ff@(posedge clk_i, negedge rstn_i) begin
        if(~rstn_i) begin
            state <= IDLE;
            tx_data_t_o <= '0;
            tx_rdy_t_o <= '0;
            data_cnt <= '0;
            res_cnt <= '0;
            res_reg <= '1;
            data_reg <= '0;
            addr_o <= '0;
            end_addr <= '0;
            res_flg <= '0;
        end
        else case(state)
                IDLE: if(rx_data_en_i)
                        if(~hex_flg_i || rx_data_r_i[9] || rx_data_r_i[8]) begin
                            state <= TRES;
                            addr_o <= ERR_A0_MX;
                            end_addr <= ERR_A1_MX;
                        end
                        else if(hex_flg_i) begin
                              addr_o <= RES_A0;
                              end_addr <= RES_A1;
                              data_reg <= {data_reg[DATA_RX_W-5 :0], dc_hex_data_i};
                              data_cnt <= data_cnt + 1'b1;
                              state <= RDT;
                          end
                      else state <= IDLE;
                RDT: if(rx_data_en_i)
                          if(~hex_flg_i || rx_data_r_i[9] || rx_data_r_i[8]) begin
                              state <= TRES;
                              addr_o <= ERR_A0_MX;
                              end_addr <= ERR_A1_MX;
                          end
                          else if(hex_flg_i) begin
                              data_reg <= {data_reg[DATA_RX_W-5 :0], dc_hex_data_i};
                              data_cnt <= data_cnt + 1'b1;
                              if(data_cnt == 2*N-1) begin
                                  data_cnt <= '0;
                                  state <= RCR;
                              end
                              else state <= RDT;
                          end
                     else state <= RDT;
                RCR: if(rx_data_en_i) begin
                        if(~(rx_data_r_i[7:0] == 8'h0d) || rx_data_r_i[9] || rx_data_r_i[8]) begin
                            state <= TRES;
                            addr_o <= ERR_A0_MX;
                            end_addr <= ERR_A1_MX;
                        end
                        else if(rx_data_r_i[7:0] == 8'h0d) state <= RLF;
                     end
                     else state <= RCR;
                RLF: if(rx_data_en_i)
                        if(~(rx_data_r_i[7:0] == 8'h0a) || rx_data_r_i[9] || rx_data_r_i[8]) begin
                            state <= TRES;
                            addr_o <= ERR_A0_MX;
                            end_addr <= ERR_A1_MX;
                        end
                        else if(rx_data_r_i[7:0] == 8'h0a) begin 
                            state <= TRES;
                            res_reg <= res_reg - data_reg; // -
                            res_flg <= '1;
                         end
                     else state <= RLF;
                TRES: begin
                    tx_data_t_o <= data_i;
                    tx_rdy_t_o <= '1;
                    addr_o <= addr_o + 1'b1;
                    state <= TMEM;
                end
                TMEM: begin
                    if(tx_rdy_r_i) 
                        if(addr_o == end_addr + 1'b1)
                            if(res_flg) begin
                                res_flg <= '0;
                                tx_data_t_o <= dc_ascii_data_i;
                                res_cnt <= res_cnt + 1'b1;
                                state <= TDT;
                            end
                            else begin
                                tx_data_t_o <= 8'h0d;
                                state <= TCR;
                            end
                    
                        else begin
                            tx_data_t_o <= data_i;
                            addr_o <= addr_o + 1'b1;
                            state <= TMEM;
                        end
                    else state <= TMEM;
                   
                end
                TDT: begin
                    if(tx_rdy_r_i) begin
                        if(res_cnt == K) begin
                            tx_data_t_o <= 8'h0d;
                            res_cnt <= '0;
                            state <= TCR;
                        end
                        else begin
                            tx_data_t_o <= dc_ascii_data_i;
                            res_cnt <= res_cnt + 1'b1;
                            state <= TDT;
                        end
                    end
                else state <= TDT;
                end
                TCR: if(tx_rdy_r_i) begin
                    tx_data_t_o <= 8'h0a;
                    state <= TLF;
                end
                else state <= TCR;
                TLF: if(tx_rdy_r_i) begin
                    tx_rdy_t_o <= '0;
                    state <= IDLE;
                end
                else state <= TLF;
             endcase
    end 

    assign ascii_data_o = rx_data_r_i;

    assign RES_A0 = START_ADDR_RES_M;
    assign RES_A1 = END_ADDR_RES_M;


    always_comb begin
        {ERR_A0_MX, ERR_A1_MX} = '0;
        case(rx_data_r_i[9:8])
            2'b00: begin ERR_A0_MX = START_EADDR_OP_F;  ERR_A1_MX = END_EADDR_OP_F;  end
            2'b01: begin ERR_A0_MX = START_EADDR_PR;    ERR_A1_MX = END_EADDR_PR;    end
            2'b10: begin ERR_A0_MX = START_EADDR_FR;    ERR_A1_MX = END_EADDR_FR;    end
            2'b11: begin ERR_A0_MX = START_EADDR_FR_PR; ERR_A1_MX = END_EADDR_FR_PF; end
        endcase
    end

    always_comb begin
        hex_data_o =  res_reg[((4*K)-1) - 4*res_cnt -: 4];
    end

endmodule