module is_uart_dec_ascii_hex
import is_pkg_uart_controller::*;
(
    input  logic [DATA_W-1 :0] ascii_data_i,
    
    output logic [3:0] hex_data_o,
    output logic hex_flg_o
);

    always_comb begin
        {hex_data_o, hex_flg_o} = '0;
        case(ascii_data_i)
            8'h30: begin hex_data_o = 4'h0; hex_flg_o = '1; end
            8'h31: begin hex_data_o = 4'h1; hex_flg_o = '1; end
            8'h32: begin hex_data_o = 4'h2; hex_flg_o = '1; end
            8'h33: begin hex_data_o = 4'h3; hex_flg_o = '1; end
            8'h34: begin hex_data_o = 4'h4; hex_flg_o = '1; end
            8'h35: begin hex_data_o = 4'h5; hex_flg_o = '1; end
            8'h36: begin hex_data_o = 4'h6; hex_flg_o = '1; end
            8'h37: begin hex_data_o = 4'h7; hex_flg_o = '1; end
            8'h38: begin hex_data_o = 4'h8; hex_flg_o = '1; end
            8'h39: begin hex_data_o = 4'h9; hex_flg_o = '1; end
            8'h41,
            8'h61: begin hex_data_o = 4'ha; hex_flg_o = '1; end
            8'h42,
            8'h62: begin hex_data_o = 4'hb; hex_flg_o = '1; end
            8'h43,
            8'h63: begin hex_data_o = 4'hc; hex_flg_o = '1; end
            8'h44,
            8'h64: begin hex_data_o = 4'hd; hex_flg_o = '1; end
            8'h45,
            8'h65: begin hex_data_o = 4'he; hex_flg_o = '1; end
            8'h46,
            8'h66: begin hex_data_o = 4'hf; hex_flg_o = '1; end
            default: begin {hex_data_o, hex_flg_o} = 'x; end
        endcase
    end
    
endmodule
