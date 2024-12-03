module is_uart_rom
import is_pkg_uart_controller::*;
(
    input  logic [MEM_WIDTH-1 :0] rom_addr_i,
    
    output logic [DATA_W-1 :0] rom_data_o
);

    logic [DATA_W-1 :0] mem [ROM_W-1 :0];

    initial $readmemh("ROM.mem", mem);

    assign rom_data_o = mem[rom_addr_i];
    
endmodule