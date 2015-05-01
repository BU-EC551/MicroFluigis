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
    rx_data1,
    rx_data_rdy1,
    rx_data2,
    rx_data_rdy2,
    data_out,
    buffer_ready
    );

// ===========================================================================
// 										Port Declarations
// ===========================================================================
    input clk;
    input [5:0] sel;
    input [7:0] rx_data1;
    input rx_data_rdy1;
    input [7:0] rx_data2;
    input rx_data_rdy2;
    output [7:0] data_out;
    output buffer_ready;

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================

	// Output wire
	wire [7:0] data_out;
	
	//  Hexadecimal values below represent ASCII characters
	reg [7:0] command[0:45] = {
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
													8'h72,		// r		pos-11
													8'h65,		// e			
													8'h64,		// d
													
													8'h42,		// B
													8'h2D,		// -
													8'h62,		// b        pos-16
													8'h6C,		// l
													8'h75,		// u

													8'h47,		// G
                                                    8'h2D,      // -
                                                    8'h67,      // g        pos-21
                                                    8'h72,      // r
                                                    8'h65,      // e

													// Set the cursor position to row 1 column 0
													8'h1B,		// Esc
													8'h5B,		// [
													8'h31,		// 1			is number one not L
													8'h3B,		// ;
													8'h30,		// 0
													8'h48,		// H
													
													// Text to print out on the screen
                                                    8'h52,      // R
                                                    8'h2D,      // -
                                                    8'h72,      // r            pos-32
                                                    8'h65,      // e            
                                                    8'h64,      // d
                                                    
                                                    8'h42,      // B
                                                    8'h2D,      // -
                                                    8'h62,      // b            pos-37
                                                    8'h6C,      // l
                                                    8'h75,      // u

                                                    8'h47,      // G
                                                    8'h2D,      // -
                                                    8'h67,      // g         pos-42
                                                    8'h72,      // r
                                                    8'h65,      // e

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

  reg             old_rx_data_rdy1;
  reg             old_rx_data_rdy2;
  reg  [7:0]      char_data1;
  reg  [7:0]      char_data2;
  reg  [3:0]      position1;
  reg  [3:0]      position2;
  reg      buffer_rdy;
  parameter [5:0]      color1[0:8] = {6'b001011,6'b001100,6'b001101,//sensor1
                                      6'b010000,6'b010001,6'b010010,
                                      6'b010101,6'b010110,6'b010111};
 parameter [5:0]      color2[0:8] =  {6'b100000,6'b100001,6'b100010,//sensor2
                                      6'b100101,6'b100110,6'b100111,
                                      6'b101010,6'b101011,6'b101100};

  

//***************************************************************************
// Wire declarations
//***************************************************************************

//***************************************************************************
// Code
//***************************************************************************
 initial begin
   position1 = 0;
   position2 = 0;
  end
  
  
  always @(posedge clk)
  begin

          // Capture the value of rx_data_rdy for edge detection
        old_rx_data_rdy1 <= rx_data_rdy1;
        old_rx_data_rdy2 <= rx_data_rdy2;
          // If rising edge of rx_data_rdy, capture rx_data
        if (rx_data_rdy1 && !old_rx_data_rdy1)
        begin
            char_data1 <= rx_data1;

            if (rx_data1 == 8'b00001101)
                begin
                buffer_rdy <= 1'b0;
                position1 <= 4'd0;
                end
            else
                begin
                buffer_rdy <= 1'b1;
                if(rx_data1 == 8'h2C)
                    begin
                    if(position1 < 4)position1 <= 4'd3;
                    else if(position1 < 7)position1 <= 4'd6; 
                    else position1 <= 4'b1000;
                    end
                else
                    begin
                    if(position1 == 4'd0)
                        begin
                            command[11] = 8'h20;
                            command[12] = 8'h20;
                            command[13] = 8'h20;
                            command[16] = 8'h20;
                            command[17] = 8'h20;
                            command[18] = 8'h20;
                            command[21] = 8'h20;
                            command[22] = 8'h20;
                            command[23] = 8'h20;
                            command[color1[position1]] = rx_data1;
                            position1 = position1 + 4'd1;   
                            if(position1 >= 4'b1001)
                                                position1 <= 4'd0;                    
                        end
                    else 
                        begin 
                        if(rx_data1 == 8'h2A)
                            begin
                            position1 = position1 + 4'd1;
                            if(position1 >= 4'b1001)
                                                position1 <= 4'd0;
                            end
                        else 
                            begin
                            command[color1[position1]] = rx_data1;
                            position1 = position1 + 4'd1;
                            if(position1 >= 4'b1001)
                                                position1 <= 4'd0;
                            end
                        end
                    end
             end
        end//end the first if
        if(rx_data_rdy2 && !old_rx_data_rdy2)
            begin
                    char_data2 <= rx_data2;
        
                    if (rx_data2 == 8'b00001101)
                        begin
                        buffer_rdy <= 1'b0;
                        position2 <= 4'd0;
                        end
                    else
                        begin
                        buffer_rdy <= 1'b1;
                        if(rx_data2 == 8'h2C)
                            begin
                            if(position2 < 4)position2 <= 4'd3;
                            else if(position2 < 7)position2 <= 4'd6; 
                            else position2 <= 4'b1000;
                            end
                        else
                            begin
                            if(position2 == 4'd0)
                                begin
                                    command[32] = 8'h20;
                                    command[33] = 8'h20;
                                    command[34] = 8'h20;
                                    command[37] = 8'h20;
                                    command[38] = 8'h20;
                                    command[39] = 8'h20;
                                    command[42] = 8'h20;
                                    command[43] = 8'h20;
                                    command[44] = 8'h20;
                                    command[color2[position2]] = rx_data2;
                                    position2 = position2 + 4'd1;   
                                    if(position2 >= 4'b1001)
                                                        position2 <= 4'd0;                    
                                end
                            else 
                                begin 
                                if(rx_data2 == 8'h2A)
                                    begin
                                    position2 = position2 + 4'd1;
                                    if(position2 >= 4'b1001)
                                                        position2 <= 4'd0;
                                    end
                                else 
                                    begin
                                    command[color2[position2]] = rx_data2;
                                    position2 = position2 + 4'd1;
                                    if(position2 >= 4'b1001)
                                                        position2 <= 4'd0;
                                    end
                                end
                            end
                     end
                end//end the second if

  end // always


endmodule
