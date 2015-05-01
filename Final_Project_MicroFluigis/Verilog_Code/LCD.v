`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineers: Andrew Skreen
//				  Josh Sackos
// 
// Create Date:    15:20:31 06/15/2012 
// Module Name:    PmodCLS_Demo 
// Project Name:	 PmodCLS_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: 	 Prints "Hello From Digilent" on PmodCLS connected to Nexys3
//						 on pins JA1-JA4. SPI protocol is utilized for communications
//						 between the PmodCLS and the Nexys3, hence the appropriate
//						 jumpers should be set on the PmodCLS, for details see
//						 PmodCLS reference manual.
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module LCD(
    clk,
    sw,
    JA,
    rx_data1,                      // 8 bit data output
                                   //  - valid when rx_data_rdy is asserted
    rx_data2, 
    rx_data_rdy1,
    rx_data_rdy2                  // Ready signal for rx_data
//	 led
    );

	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
	input clk;						// Onboard 100 Mhz clock signal
	input [3:0] sw;				// SW[0]=reset, SW[1]=clear, SW[2]=start, SW[3]=continue display
	output [3:0] JA;				// JA[0]=slave select
										// JA[1]=mosi
										// JA[2]=miso
										// JA[3]=sclk
	input      [7:0] rx_data1;  
	input            rx_data_rdy1;
	input      [7:0] rx_data2;  
    input            rx_data_rdy2;
//	output [0:0] led;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
	wire [3:0] JA;					// Output wires for SPI communication with PmodCLS
	wire [0:0] led;

	wire slave_select;			// Active low signal for writing data to PmodCLS
	wire begin_transmission;	// Initializes data transfer with PmodCLS
	wire end_transmission;		// Handshake signal to signify data transfer done
	wire [5:0] sel;				// Selects which ASCII value to send to PmodCLS
	wire [7:0] temp_data;		// Output data from C2 to C0
	wire [7:0] send_data;		// Output data from C0 to C1
	
	wire CONTINUE_DISPLAY;
	wire START;						// Debounced start signal, SW[2]
	wire CLEAR;						// Debounced clear signal, SW[1]
	wire RST;						// Debounced reset signal, SW[0]
	wire GND = 0;					// Ground, i.e. logic low
	wire buffer_ready;

	// ===========================================================================
	// 										Implementation
	// ===========================================================================

	// Debounces the input control signals from switches.
	Three_Bit_Debouncer DebounceInputs(
			.CLK(clk),
			.RST(GND),
			.I0(sw[0]),
			.I1(sw[1]),
			.I2(sw[2]),
			.I3(sw[3]),
			.D0(RST),
			.D1(CLEAR),
			.D2(START),
			.D3(CONTINUE_DISPLAY)
	);

	// Produces signals for controlling SPI interface, and selecting output data.
	master_interface C0( 
			.begin_transmission(begin_transmission),
			.end_transmission(end_transmission),
			.clk(clk),
			.rst(RST),
			.start(START),
			.clear(CLEAR),
			.continue_display(CONTINUE_DISPLAY),
			.buffer_ready(buffer_ready),
			.slave_select(slave_select),
			.temp_data(temp_data),
			.send_data(send_data),
			.sel(sel)
	);

	// Interface between the PmodCLS and FPGA, proeduces SCLK signal, etc.
	spi_interface C1(
			.begin_transmission(begin_transmission),
			.slave_select(slave_select),
			.send_data(send_data),
			.miso(JA[2]),
			.clk(clk),
			.rst(RST),
			.end_transmission(end_transmission),
			.mosi(JA[1]),
			.sclk(JA[3])
	);

	// Contains the ASCII characters for commands
	command_lookup C2(
	        .clk(clk),
			.sel(sel),
			.rx_data1(rx_data1),
			.rx_data_rdy1(rx_data_rdy1),
			.rx_data2(rx_data2),
            .rx_data_rdy2(rx_data_rdy2),
			.data_out(temp_data),
			.buffer_ready(buffer_ready)
	);

	//  Active low slave select signal
	assign JA[0] = slave_select;

	// Assign Led[0] the value of SW[0]
	assign led[0] = sw[0];

endmodule
