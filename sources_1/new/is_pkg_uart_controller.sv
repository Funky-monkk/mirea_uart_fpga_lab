package is_pkg_uart_controller;

//===================
//--- Common Param
//===================

localparam DATA_W = 8;
localparam ADDR_W = 8;
localparam ROM_W  = 128;
localparam RATIO = 8;
localparam MEM_WIDTH = 2;
localparam N = 0;
localparam DATA_FSM_W = 48;
localparam DATA_RES_W = 92;
localparam ERR_A0_MX = 0;
localparam ERR_A1_MX = 0;
localparam RES_A0 = 0;
localparam RE_A1 = 0;
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
        WCE   = 3'b001,
        TSTRB = 3'b010,
        TDT   = 3'b011,
        TPARB = 3'b100,
        TSTB1 = 3'b101,
        TSTB2 = 3'b110,
        XXX   = 'x } state_t;

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

endpackage 
