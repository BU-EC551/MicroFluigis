`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2015 10:20:01 AM
// Design Name: 
// Module Name: tb_lcd
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
module tb_lcd;

    reg clk;
    reg [5:0] sel;
    reg [7:0] rx_data;
    reg rx_data_rdy;
    wire [7:0]temp_data;
    wire buffer_ready;
    	
	command_lookup uut1(
        .clk(clk),
        .sel(sel),
        .rx_data(rx_data),
        .rx_data_rdy(rx_data_rdy),
        .data_out(temp_data),
        .buffer_ready(buffer_ready)
    );

  	// generate clock to sequence tests
    always
    begin
     	clk <= 1; # 5; clk <= 0; # 5;
    end
    	
    
      	// initialize test
    initial
      begin
        sel <= 5'b000000;
        rx_data_rdy <= 0;
      end

      	// check results
    always@(negedge clk)
      begin
            if(sel == 5'b100001) 
                sel <= 0;
            else
                sel <= sel + 1;
      end
endmodule
