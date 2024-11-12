package is_pkg_uart_controller;

//===================
//--- Common Param
//===================

localparam DATA_W = 8;
localparam ADDR_W = 8;
localparam ROM_W  = 128;

//====================



    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        RSTRB = 3'b001,
        RDT   = 3'b010,
        RPARB = 3'b011,
        RSTB1 = 3'b100,
        RSTB2 = 3'b101,
        WEND  = 3'b110,
        XXX   = 'x } state_r;

        typedef enum logic [2:0] {
            IDLE  = 3'b000,
            WCE = 3'b001,
            TSTRB   = 3'b010,
            TDT = 3'b011,
            TPARB = 3'b100,
            TSTB1 = 3'b101,
            TSTB2  = 3'b110,
            XXX   = 'x } state_t;

endpackage 
