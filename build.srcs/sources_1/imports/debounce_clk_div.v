`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    15:20:31 06/15/2012 
// Module Name:    Debounce_Clk_Div
// Project Name:	 PmodCLS_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: 	 Produces a slower clock signal used for sampling the logic
//						 levels of the inputs.
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module Debounce_Clk_Div(
		CLK,
		RST,
		CLKOUT
);

	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
   input            CLK;
   input            RST;
   output           CLKOUT;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
   reg              CLKOUT;
   reg [15:0]       cntval;						//  Current amount counted to

   parameter [15:0] cntendval = 16'hC350;		//  Maximum counting value

	// ===========================================================================
	// 										Implementation
	// ===========================================================================
   

	//  Count Process
   always @(posedge CLK or posedge RST) begin
      
      //  If the reset button is pressed then start counting from zero again
      if (RST == 1'b1) begin
         cntval <= 16'h0000;
      end
      //  Otherwise proceed with count
      else begin
         //  If cntval has reached the max value output signal and reset to zeros
         if (cntval == cntendval) begin
            cntval <= 16'h0000;
            CLKOUT <= 1'b1;
         end
         else begin
            //  Increment cntval
            cntval <= cntval + 16'h0001;
            CLKOUT <= 1'b0;
         end
      end
	end
	// End Count Process
   
endmodule
