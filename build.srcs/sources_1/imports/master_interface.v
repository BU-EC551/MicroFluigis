`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineers: Andrew Skreen
//				  Josh Sackos
// 
// Create Date:    16:31:34 06/15/2012 
// Module Name:    master_interface 
// Project Name: 	 PmodCLS_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Contains the state machine which controls the SPI interface.
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module master_interface(
    clk,
    rst,
    temp_data,
    clear,
    end_transmission,
    start,
    continue_display,
    buffer_ready,
    sel,
    send_data,
    begin_transmission,
    slave_select
    );

	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
    input clk;
    input rst;
    input [7:0] temp_data;
    input clear;
    input end_transmission;
    input start;
    input continue_display;
    input buffer_ready;
    output [5:0] sel;
    output [7:0] send_data;
    output begin_transmission;
    output slave_select;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================

	// Output wires and registers
	wire [5:0] sel;
	reg [7:0] send_data = 8'h00;
	reg begin_transmission;
	reg slave_select;

	// FSM states
	parameter [2:0] stateIdle = 0,
						 stateClearing = 1,
						 stateDisplay = 2,
						 stateWaitRun = 3,
						 stateWaitSS = 4,
						 stateFinished = 5;
						 
	// Stores the current state
	reg [2:0] STATE;
	// Stores the last state
	reg [2:0] prevSTATE;
	// Used to select data sent to SPI Interface component and used for FSM control
	reg [5:0] count_sel;
	// Counts up to COUNT_SS_MAX, once reached the SS is asserted (i.e. shut off)
	reg [11:0] count_ss;
	// Determines the duration that SS is deasserted (i.e. turned on)	
	parameter [11:0] COUNT_SS_MAX = 12'hFFF;		// 4095
	// Signal to execute a reset on the PmodCLS
	reg exeRst = 0;
	 
	// ===========================================================================
	// 										Implementation
	// ===========================================================================
	

	//  Signal to select the data to be sent to the PmodCLS
	assign sel = count_sel;


	// Master Interface FSM
	always @(posedge clk) begin
			
			// Reset
			if(rst == 1'b1) begin
					STATE <= stateIdle;
					prevSTATE <= stateIdle;
					count_sel <= 6'b000000;
					send_data <= 8'h00;
					slave_select <= 1'b1;
					count_ss <= 12'h000;
					begin_transmission <= 1'b0;
					exeRst <= 1'b1;
			end
			else begin

					case(STATE)
							
							// Idle State
							stateIdle : begin
									count_sel <= 6'b000000;
									slave_select <= 1'b1;
									
									if((start == 1'b1) && (clear == 1'b0) && (exeRst != 1'b1)) begin
											slave_select <= 1'b0;
											STATE <= stateDisplay;
											prevSTATE <= stateIdle;
									end
									else if((clear == 1'b1) || (exeRst == 1'b1)) begin
											slave_select <= 1'b0;
											STATE <= stateClearing;
											prevSTATE <= stateIdle;
									end
									else begin
											// Null
									end
							end

							// Clearing State
							stateClearing : begin
									prevSTATE <= stateClearing;
									send_data <= temp_data;
									begin_transmission <= 1'b1;
									
									if(count_sel == 6'b000011) begin
											STATE <= stateWaitSS;
											count_sel <= 6'b000000;
									end
									else begin
											STATE <= stateWaitRun;
									end
							end

							// Display State
							stateDisplay : begin
									prevSTATE <= stateDisplay;
									send_data <= temp_data;
									begin_transmission <= 1'b1;

									if(count_sel == 6'd33) begin
											STATE <= stateWaitSS;
											count_sel <= 6'd0;
									end
									else begin
											STATE <= stateWaitRun;
									end
							end

							// WaitRun State
							stateWaitRun : begin
									begin_transmission <= 1'b0;
									if(end_transmission == 1'b1) begin
											STATE <= prevSTATE;
											count_sel <= count_sel + 1'b1;
									end
									else begin
											// Null
									end
							end

							// WaitSS State
							stateWaitSS : begin
									begin_transmission <= 1'b0;
									
									if(count_ss == COUNT_SS_MAX) begin
//									        if(continue_display == 1'b1) 
//									           begin
//									           STATE <= stateDisplay;
//									           count_ss <= 6'b000000;
//									           end
//											else 
//											   begin
											   STATE <= stateFinished;
											   count_ss <= 6'b000000;
											   slave_select <= 1'b1;
//											   end
									end
									else begin
											count_ss <= count_ss + 1'b1;
									end
							end

							// Finished State
							stateFinished : begin

									exeRst <= 1'b0;

									if((start == 1'b0 && clear == 1'b0)||((continue_display == 1'b1)&&(buffer_ready == 1'b1))) begin
											STATE <= stateIdle;
											prevSTATE <= stateFinished;
									end
							end

							// When signals indicate an invalid state
							default : begin
									// Null
							end
					endcase
			end
	end
	// End Master Interface FSM

endmodule
