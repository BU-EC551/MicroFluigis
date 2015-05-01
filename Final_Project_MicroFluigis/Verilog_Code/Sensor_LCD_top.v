`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2015 11:03:05 PM
// Design Name: 
// Module Name: Sensor_LCD_top
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


module Sensor_LCD_top(
           input [3:0]sw,
           input clk,
    	   input UART_RXD1,
    	   input UART_RXD2,
           output [3:0]JA           
    );

async_receiver rx1(
		.clk(clk),
		.RxD(UART_RXD1),
		.RxD_data_ready(RxD_data_ready1),
		.RxD_data(RxD_data1)
	);
	
async_receiver rx2(
            .clk(clk),
            .RxD(UART_RXD2),
            .RxD_data_ready(RxD_data_ready2),
            .RxD_data(RxD_data2)
        );

LCD lcd1(
        .clk(clk),
        .sw(sw),
        .rx_data1(RxD_data1),
        .rx_data2(RxD_data2),
        .rx_data_rdy1(RxD_data_ready1),
        .rx_data_rdy2(RxD_data_ready2),
        .JA(JA)  
);


wire [7:0] RxD_data1;
wire [7:0] RxD_data2;
wire RxD_data_ready1;
wire RxD_data_ready2;

endmodule
