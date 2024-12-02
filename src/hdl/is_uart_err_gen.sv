module is_uart_err_gen
(

    input  logic [9:0] rx_data_t_i,
    input  logic       gen_frt_err_i,
    input  logic       gen_par_err_i,

    output logic [9:0] data_o
);

    logic frt_err;
    logic par_err;

    assign frt_err = (gen_frt_err_i == rx_data_t_i[9]);
    assign par_err = (gen_par_err_i == rx_data_t_i[8]);

    assign data_o = {frt_err, par_err, rx_data_t_i[7:0]};


endmodule