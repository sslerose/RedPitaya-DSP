`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel LeRose
// 
// Create Date: June 2023
// Design Name: 
// Module Name: e_exp_decay
// Project Name: Trapezoidal Filter
// Target Devices: Red Pitaya STEMlab 125-14
// Tool Versions: 
// Description: Provides an exponentially decaying signal using fixed-point multiplication
// Dependencies: N/A
// 
// Revision: v1.0
// 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module e_exp_decay #
(
    parameter DATA_WIDTH = 16,
    parameter DAC_WIDTH = 14
)
(
    input clk,
    input aresetn,
    input [DAC_WIDTH-1:0] sig_amp,
    input [DAC_WIDTH-1:0] decay_factor,
    output signed [DATA_WIDTH-1:0] m_axis_tdata,
    output m_axis_tvalid,
    input trigger
);
    reg [DAC_WIDTH-1:0] current_value;
    reg [2*DAC_WIDTH-1:0] mult;

    assign m_axis_tdata = current_value;
    assign m_axis_tvalid = 1;

    always @ (posedge clk) begin
        if (~aresetn) begin
            current_value <= 0;
            
        end else begin
            if (trigger) begin
	       current_value <= sig_amp;   // Set initial peak for exponential signal

            end else if (current_value != 0) begin
               mult = current_value * decay_factor; // Multiply by decay factor
	       current_value <= (mult) >> 14;       // Shift to implement fixed-point multiplication

            end
        end
    end
endmodule
