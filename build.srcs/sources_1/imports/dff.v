`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    15:20:31 06/15/2012 
// Module Name:    DFF
// Project Name:	 PmodCLS_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: 	 A one bit data flip flop.
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module DFF(
		D,
		CLK,
		RST,
		Q
);
   
// ===========================================================================
// 										Port Declarations
// ===========================================================================
   input  D;
   input  CLK;
   input  RST;
   output  Q;

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================
	reg Q = 0;

// ===========================================================================
// 										Implementation
// ===========================================================================

   //  On CLK read incoming data and store it
   always @(posedge CLK or posedge RST) begin
      
      if (RST == 1'b1) begin
         Q <= 1'b0;
		end
      else begin
         Q <= D;
		end
		
	end
   
endmodule
