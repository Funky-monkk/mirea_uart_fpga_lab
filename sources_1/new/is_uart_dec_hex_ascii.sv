module is_uart_dec_hex_ascii
import is_pkg_uart_controller::*;
(
    input  logic hex_data_i,
    
    output logic [DATA_W-1 :0] ascii_data_o
);


    always_comb begin
        {ascii_data_o} = '0;
        case(hex_data_i)
            4'h0: begin ascii_data_o = 8'h30; end
            4'h1: begin ascii_data_o = 8'h31; end
            4'h2: begin ascii_data_o = 8'h32; end
            4'h3: begin ascii_data_o = 8'h33; end
            4'h4: begin ascii_data_o = 8'h34; end
            4'h5: begin ascii_data_o = 8'h35; end
            4'h6: begin ascii_data_o = 8'h36; end
            4'h7: begin ascii_data_o = 8'h37; end
            4'h8: begin ascii_data_o = 8'h38; end
            4'h9: begin ascii_data_o = 8'h39; end
            4'ha: begin ascii_data_o = 8'h41; end
            4'hb: begin ascii_data_o = 8'h42; end
            4'hc: begin ascii_data_o = 8'h43; end
            4'hd: begin ascii_data_o = 8'h44; end
            4'he: begin ascii_data_o = 8'h45; end
            4'hf: begin ascii_data_o = 8'h46; end
            default: ascii_data_o = 'x;
        endcase
    end

endmodule