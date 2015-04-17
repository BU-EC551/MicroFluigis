`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineers: Andrew Skreen
//				  Josh Sackos
// 
// Create Date:    12:15:47 06/18/2012
// Module Name:    command_lookup
// Project Name: 	 PmodCLS Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Contains the data commands to be sent to the PmodCLS.  Values
//					 are ASCII characters, for details on data format, etc., see
//					 the PmodCLS reference manual.
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module command_lookup(
    clk,
    sel,
    rx_data,
    rx_data_rdy,
    data_out,
    buffer_ready
    );

// ===========================================================================
// 										Port Declarations
// ===========================================================================
    input clk;
    input [5:0] sel;
    input [7:0] rx_data;
    input rx_data_rdy;
    output [7:0] data_out;
    output buffer_ready;

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================

	// Output wire
	wire [7:0] data_out;
	
	//  Hexadecimal values below represent ASCII characters
	reg [7:0] command[0:33] = {
													// Clear the screen and set cursor position to home
													8'h1B,		// Esc
													8'h5B,		// [
													8'h6A,		// j

													// Set the cursor position to row 0 column 0
													8'h1B,		// Esc
													8'h5B,		// [
													8'h30,		// 0
													8'h3B,		// ;
													8'h30,		// 0
													8'h48,		// H

													// Text to print out on the screen
													8'h52,		// R
													8'h2D,		// -
													8'h72,		// r			is lowercase L, not number one  pos-11
													8'h65,		// e			is lowercase L, not number one
													8'h65,		// d
													8'h20,		// Space
													8'h42,		// B
													8'h2D,		// -
													8'h62,		// b            pos-17
													8'h6C,		// l
													8'h75,		// u
													8'h20,		// Space


													// Set the cursor position to row 1 column 0
													8'h1B,		// Esc
													8'h5B,		// [
													8'h31,		// 1			is number one not L
													8'h3B,		// ;
													8'h30,		// 0
													8'h48,		// H

													8'h47,		// G
                                                    8'h2D,        // -
                                                    8'h67,        // g         pos-29
                                                    8'h72,        // r
                                                    8'h65,        // e
                                                    8'h20,        // Space

//													// Text to print out on the screen
//													8'h44,		// D
//													8'h69,		// i
//													8'h67,		// g
//													8'h69,		// i
//													8'h6C,		// l			is lowercase L, not number one
//													8'h65,		// e
//													8'h6E,		// n
//													8'h74,		// t

													8'h00		// Null

	};
	 
// ===========================================================================
// 										Implementation
// ===========================================================================
	
	// Assign byte to output
	assign data_out = command[sel];
	assign buffer_ready = buffer_rdy;

//***************************************************************************
// Reg declarations
//***************************************************************************

  reg             old_rx_data_rdy;
  reg  [7:0]      char_data;
  reg  [31:0]     sseg_data;
  reg  [4:0]      position;
  reg      buffer_rdy;
  parameter [4:0]      color[0:8] = {5'b01011,5'b01100,5'b01101,
                                    5'b10001,5'b10010,5'b10011,
                                    5'b11101,5'b11110,5'b11111};

  

//***************************************************************************
// Wire declarations
//***************************************************************************

//***************************************************************************
// Code
//***************************************************************************

  always @(posedge clk)
  begin
//    if (rst_clk_rx)
//    begin
//      old_rx_data_rdy <= 1'b0;
//      char_data       <= 8'b0;
//      led_o           <= 8'b0;
//    end
//    else
//        begin
          // Capture the value of rx_data_rdy for edge detection
        old_rx_data_rdy <= rx_data_rdy;
    
          // If rising edge of rx_data_rdy, capture rx_data
        if (rx_data_rdy && !old_rx_data_rdy)
            begin
            char_data <= rx_data;
            if (rx_data == 8'b00001101)
                begin
                buffer_rdy <= 0;
                position <= 0;
                end
            else
                begin
                buffer_rdy <= 1;
                if(rx_data == 8'h2C)
                    begin
                    if(position < 4)position <= 3;
                    else if(position < 7)position <= 6; 
                    else position <= 5'b01001;
                    end
                else
                    begin
                    if(position == 0)
                        begin
                            command[11] = 8'h20;
                            command[12] = 8'h20;
                            command[13] = 8'h20;
                            command[17] = 8'h20;
                            command[18] = 8'h20;
                            command[19] = 8'h20;
                            command[29] = 8'h20;
                            command[30] = 8'h20;
                            command[31] = 8'h20;
                            command[color[position]] = rx_data;
                            position = position + 1;
                        end
                    else 
                        begin 
                        if(rx_data == 8'h2A) position = position + 1;
                        else begin
                            command[color[position]] = rx_data;
                            position = position + 1;
                            end
                        end
                    end
                
                if(position == 5'b01010) position <= 0;
                end
        end
    //        led_o <= char_data;
//    end // if !rst
  end // always


endmodule
