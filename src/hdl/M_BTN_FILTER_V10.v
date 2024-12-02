`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        Argon
// Engineer:       FPGA-Mechanic
//
// Create Date:    15:23:33 12/17/2013
// Design Name:    Any Device With Button
// Module Name:    M_BTN_FILTER_V10
// Target Devices: FPGA or CPLD
//////////////////////////////////////////////////////////////////////////////////
module M_BTN_FILTER_V10(
    input      CLK,                     // System Clock
    input      CE,                      // CE (1-2kHz - optimal)
    input      BTN_IN,                  // Asynch. Input From Button
    input      RST,                     // Asynch. Reset
    output     BTN_OUT,                 // Filtered Output
    output reg BTN_CEO                  // Clock Enable Pulse When L-H Transition
    );

 parameter [3:0] CNTR_WIDTH = 4;        // Internal Counter Width

// Internal signals declaration:
 reg [CNTR_WIDTH - 1:0] FLTR_CNT;
 reg BTN_D, BTN_S1, BTN_S2;
//------------------------------------------
// Main Counter:
 always @ (posedge CLK, posedge RST)
  if(RST) FLTR_CNT <= {CNTR_WIDTH{1'b0}};
  else
   if(!(BTN_S1 ^ BTN_S2))               // if BTN_S1 = BTN_S2
    FLTR_CNT <= {CNTR_WIDTH{1'b0}};     // Return to Zero
   else if(CE)                          // else if Clock Enable
    FLTR_CNT <= FLTR_CNT + 1;           // Increment
//------------------------------------------
// Input Synchronizer:
 always @ (posedge CLK, posedge RST)
  if(RST)
   begin
    BTN_D  <= 1'b0;
    BTN_S1 <= 1'b0;
   end
  else
   begin
    BTN_D  <= BTN_IN;
    BTN_S1 <= BTN_D;
   end
//------------------------------------------
// Output Register:
 always @ (posedge CLK, posedge RST)
  if(RST) BTN_S2 <= 1'b0;
  else if(&(FLTR_CNT) & CE) BTN_S2 <= BTN_S1;
//------------------------------------------
// Output Front Detector Clock Enable:
 always @ (posedge CLK, posedge RST)
  if(RST) BTN_CEO <= 1'b0;
  else BTN_CEO <= &(FLTR_CNT) & CE & BTN_S1;
//------------------------------------------
 assign BTN_OUT = BTN_S2;
//------------------------------------------
endmodule
