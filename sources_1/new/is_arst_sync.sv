`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2024 20:36:45
// Design Name: 
// Module Name: is_arst_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module is_arst_sync
(
    input  logic clk_i,
    input  logic a_rstn_i,
    
    output logic sync_rstn_o
);

    logic rst_ff1;
            
    always_ff @(posedge clk_i, negedge a_rstn_i)
        if(~a_rstn_i) {sync_rstn_o,rst_ff1} <= '0;
        else          {sync_rstn_o,rst_ff1} <= {rst_ff1, 1'b1};

endmodule
