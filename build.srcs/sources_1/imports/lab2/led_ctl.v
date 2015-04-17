//-----------------------------------------------------------------------------
//  
//  Copyright (c) 2009 Xilinx Inc.
//
//  Project  : Programmable Wave Generator
//  Module   : led_ctl.v
//  Parent   : uart_led.v
//  Children : None
//
//  Description: 
//     LED output generator
//
//  Parameters:
//     None
//
//  Local Parameters:
//
//  Notes       : 
//
//  Multicycle and False Paths
//    None
//

`timescale 1ns/1ps


module led_ctl (
  // Write side inputs
  input            clk_rx,       // Clock input
  input            rst_clk_rx,   // Active HIGH reset - synchronous to clk_rx
  input      [7:0] rx_data,      // 8 bit data output
                                 //  - valid when rx_data_rdy is asserted
  input            rx_data_rdy,  // Ready signal for rx_data

  output reg [15:0] led_o,         // The LED outputs
  output reg [15:0] sseg_o
);


//***************************************************************************
// Parameter definitions
//***************************************************************************

//***************************************************************************
// Reg declarations
//***************************************************************************

  reg             old_rx_data_rdy;
  reg  [7:0]      char_data;
  reg  [31:0]     sseg_data;
  reg       tmp_data;
  reg      slower;

//***************************************************************************
// Wire declarations
//***************************************************************************

//***************************************************************************
// Code
//***************************************************************************

  always @(posedge clk_rx)
  begin
    if (rst_clk_rx)
    begin
      old_rx_data_rdy <= 1'b0;
      char_data       <= 8'b0;
      led_o           <= 8'b0;
    end
    else
    begin
      // Capture the value of rx_data_rdy for edge detection
      old_rx_data_rdy <= rx_data_rdy;

      // If rising edge of rx_data_rdy, capture rx_data
      if (rx_data_rdy && !old_rx_data_rdy)
      begin
      
     char_data <= rx_data;
	if (rx_data == 8'b00001101)
	begin
		sseg_o <= sseg_data[15:0];
		led_o <= sseg_data[31:16];
	end
	else
	begin
    
    
 sseg_data <= {sseg_data[27:0], rx_data[3:0]};
 end
 
//	end
	  end
//        led_o <= char_data;
    end // if !rst
  end // always
  

always @ (posedge clk_rx)begin
    slower <= slower + 1;
end

endmodule
