`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Josh Sackos
// 
// Create Date:    15:20:31 06/15/2012 
// Module Name:    Three_Bit_Debouncer
// Project Name:	 PmodCLS_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: 	 Debounces the START, CLEAR, and RESET signals comming from
//						 switches SW[2:0].
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module Three_Bit_Debouncer(
		CLK,
		RST,
		I0,
		I1,
		I2,
		I3,
		D0,
		D1,
		D2,
		D3
);
   
	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
   input   CLK;			// Onboard 100 Mhz clock signal
   input   RST;			// Reset signal
   input   I0;				// Input data 0
   input   I1;				// Input data 1
   input   I2;				// Input data 2
   input   I3;
   output  D0;				// Input data 0
   output  D1;				// Input data 1
   output  D2;				// Input data 2
   output  D3;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
   wire    D0_DFF1OUT;				// D0 input flip flop 1
   wire    D0_DFF2OUT;				// D0 input flip flop 2

   wire    D1_DFF1OUT;				// D1 input flip flop 1
   wire    D1_DFF2OUT;				// D1 input flip flop 2

   wire    D2_DFF1OUT;				// D1 input flip flop 1
   wire    D2_DFF2OUT;				// D1 input flip flop 2
   
   wire    D3_DFF1OUT;				// D1 input flip flop 1
   wire    D3_DFF2OUT;                // D1 input flip flop 2
   
   wire    DCKL;						// Clock signal debounce flip flops use

	// ===========================================================================
	// 										Implementation
	// ===========================================================================
   
   //  Debounce clock divider
   Debounce_Clk_Div DB_CLK_DIV(
			.CLK(CLK),
			.RST(RST),
			.CLKOUT(DCKL)
	);
   


   //  D0, data flip flop 1
   DFF D0_DFF1(
			.D(I0),
			.CLK(DCKL),
			.RST(RST),
			.Q(D0_DFF1OUT)
	);

   //  D0, data flip flop 2
   DFF D0_DFF2(
			.D(D0_DFF1OUT),
			.CLK(DCKL),
			.RST(RST),
			.Q(D0_DFF2OUT)
	);
	
	
	
   //  D1, data flip flop 1
   DFF D1_DFF1(
			.D(I1),
			.CLK(DCKL),
			.RST(RST),
			.Q(D1_DFF1OUT)
	);

   //  D1, data flip flop 2
   DFF D1_DFF2(
			.D(D1_DFF1OUT),
			.CLK(DCKL),
			.RST(RST),
			.Q(D1_DFF2OUT)
	);
	
	
	
   //  D2, data flip flop 1
   DFF D2_DFF1(
			.D(I2),
			.CLK(DCKL),
			.RST(RST),
			.Q(D2_DFF1OUT)
	);

   //  D2, data flip flop 2
   DFF D2_DFF2(
			.D(D2_DFF1OUT),
			.CLK(DCKL),
			.RST(RST),
			.Q(D2_DFF2OUT)
	);
	
	   //  D3, data flip flop 1
    DFF D3_DFF1(
             .D(I3),
             .CLK(DCKL),
             .RST(RST),
             .Q(D3_DFF1OUT)
     );
 
    //  D3, data flip flop 2
    DFF D3_DFF2(
             .D(D3_DFF1OUT),
             .CLK(DCKL),
             .RST(RST),
             .Q(D3_DFF2OUT)
     );
   
   //  Logical "and" both outputs of D0 flip flops to ensure no noise
   assign D0 = D0_DFF1OUT & D0_DFF2OUT;

   //  Logical "and" both outputs of D1 flip flops to ensure no noise
   assign D1 = D1_DFF1OUT & D1_DFF2OUT;
	
   //  Logical "and" both outputs of D2 flip flops to ensure no noise
   assign D2 = D2_DFF1OUT & D2_DFF2OUT;
   
   //  Logical "and" both outputs of D2 flip flops to ensure no noise
   assign D3 = D3_DFF1OUT & D3_DFF2OUT;
   
endmodule

