`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel LeRose
// 
// Create Date: June 2023
// Design Name: 
// Module Name: peak_detector
// Project Name: Trapezoidal Filter
// Target Devices: Red Pitaya STEMlab 125-14
// Tool Versions: 
// Description: Provides method of peak detection specifically for trapezoidal
//      filtration where the "peak" is the middle of the flat top.
// Dependencies: N/A
// 
// Revision: v1.0
// 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module peak_detector #
(
    parameter integer AXIS_TDATA_WIDTH = 16,
    parameter integer BUFFER_LENGTH = 14
)
(
    input clk,
    input aresetn,
    input signed [2*AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
    input s_axis_tvalid,
    output signed [2*AXIS_TDATA_WIDTH-1:0] peak,

    input [15:0] threshold,
    input [13:0] Kdelay,		// Length of rising/falling edge of trapezoid
    input [13:0] Ldelay			// Ldelay - Kdelay = length of flat-top (L >= K)
);

    reg signed [2*AXIS_TDATA_WIDTH-1:0] peak_value;
    reg [7:0] counter;
    
    assign peak = peak_value;

    always @ (posedge clk) begin
        if (~aresetn) begin
	       peak_value <= 0;
	       counter <= 0;

        end else begin
	       if (s_axis_tdata > threshold)	begin	// If data is above threshold, begin peak detection
	           if (counter == 0 && peak_value == 0) begin
	               counter <= (Kdelay + Ldelay) / 2 - 1;		// Set counter to wait for middle of flat top
	           end
	       end
	  
	       if (counter > 0) begin
	           if (counter == 1) begin
	               peak_value <= s_axis_tdata;	// At middle of flat top, record data value as peak
	           end
	           counter <= counter - 1;
	       end
/*
	       if (s_axis_tdata < threshold) begin
	           peak_value <= 0;	// Reset peak and counter when signal is under threshold
	           counter <= 0;
	       end
	       
	       if (current_peak_value > peak_value) begin
	           peak_value <= current_peak_value;
	       end
*/
	       
        end
    end
endmodule
