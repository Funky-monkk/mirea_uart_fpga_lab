package is_pkg_uart_controller;

//===================
//--- Common Param
//===================

localparam DATA_W = 8;
localparam ADDR_W = 8;
localparam ROM_W  = 128;
localparam RATIO = 8;
localparam MEM_WIDTH = 8;
localparam N = 0;
localparam DATA_RX_W = 48;
localparam DATA_TX_W = 92;

//====================

//====================
//--- Addr Map
//==================== 

    localparam START_ADDR_RES_M = 8'h00;
    localparam END_ADDR_RES_M =  8'h07;

    localparam START_EADDR_OP_F = 8'h08;
    localparam END_EADDR_OP_F = 8'h18;

    localparam START_EADDR_PR = 8'h19;
    localparam END_EADDR_PR   = 8'h28;

    localparam START_EADDR_FR = 8'h29;
    localparam END_EADDR_FR = 8'h3f;

    localparam START_EADDR_FR_PR = 8'h40;
    localparam END_EADDR_FR_PF = 8'h4a;


endpackage 
