`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel LeRose
// 
// Create Date: June 2023
// Design Name: 
// Module Name: trap_filter
// Project Name: Trapezoidal Filter
// Target Devices: Red Pitaya STEMlab 125-14
// Tool Versions: 
// Description: Digital implementation of the trapezoidal filtering method created by
// 	V. T. Jordanov and G. F. Knoll: https://doi.org/10.1016/0168-9002(94)91011-1
// Dependencies: ring_buffer
// 
// Revision: v1.0
// 
// Additional Comments: Filter arithmetic adapted from paper by Kavita Pathak and
// 	Dr. Sudhir Agrawal: https://www.ijsrp.org/research-paper-0815/ijsrp-p4475.pdf
// 
//////////////////////////////////////////////////////////////////////////////////

module trap_filter #
(
    parameter integer AXIS_TDATA_WIDTH = 16
)
(
    input clk,
    input aresetn,
    input signed [AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
    input s_axis_tvalid,
    output m_axis_tvalid,
    output signed [2*AXIS_TDATA_WIDTH-1:0] m_axis_tdata,

    input signed [15:0] mult_factor,	// mult_factor = decay time constant of signal (signed for proper filter arithmetic)
    input [13:0] Kdelay,		// Length of rising/falling edge of trapezoid
    input [13:0] Ldelay			// Ldelay - Kdelay = length of flat-top (L >= K)
);

    wire signed [AXIS_TDATA_WIDTH-1:0] K_delay_tdata;	// Data after K time delay for Sub1
    wire signed [AXIS_TDATA_WIDTH-1:0] L_delay_tdata;	// Data after L time delay for Sub2
    reg signed [AXIS_TDATA_WIDTH-1:0] K_diff_tdata;	// Diff between incoming data and data after K delay
    reg signed [AXIS_TDATA_WIDTH-1:0] L_diff_tdata;	// Diff between Sub1 data and Sub1 data after L delay
    reg signed [2*AXIS_TDATA_WIDTH-1:0] mult_tdata;	// Product of Sub2 data and multiplication factor
    reg signed [2*AXIS_TDATA_WIDTH-1:0] accu_tdata;	// Accumulation of data by adding new Sub2 data at each cycle
    reg signed [2*AXIS_TDATA_WIDTH-1:0] sum_tdata;	// Sum of multiplier and accumulator values
    reg signed [2*AXIS_TDATA_WIDTH-1:0] result_tdata;	// Accumulation of data by adding new summed data at each cycle

    reg [28:0] buff_iterate;	 	// Counter for handling ring buffers
    reg enwrK, enrdK, enrdL, enwrL;	// Enable read and write for ring buffers

    assign m_axis_tvalid = s_axis_tvalid;
    assign m_axis_tdata = result_tdata;

    ring_buffer # () K_buff
    (
        .clk(clk),
        .enrd(enrdK),
        .enwr(enwrK),
        .delay(Kdelay),
        .wr_data(s_axis_tdata),
        .rd_data(K_delay_tdata)
    );

    ring_buffer # () L_buff
    (
        .clk(clk),
        .enrd(enrdL),
        .enwr(enwrL),
        .delay(Ldelay),
        .wr_data(K_diff_tdata),
        .rd_data(L_delay_tdata)
    );

    always @ (posedge clk) begin
        // Reset handling
        if (~aresetn) begin
            K_diff_tdata <= 0;
            L_diff_tdata <= 0;
            mult_tdata <= 0;
            accu_tdata <= 0;
            sum_tdata <= 0;
            result_tdata <= 0;
            buff_iterate <= 0;
            enrdK <= 0;
            enwrK <= 0;
            enrdL <= 0;
            enwrL <= 0;

        // Buffer handling
	end else if (buff_iterate < Kdelay + Ldelay + 2) begin
            // Iterate buffer controller
            buff_iterate <= buff_iterate + 1;

	    // Enable K_buff write (if it is off)
	    if (~enwrK) begin
	        enwrK <= 1;
	    end

            // Enable K_buff read (if it is off) after K_buff has written to Kdelay - 2 number of registers
            if (buff_iterate > Kdelay - 3 && ~enrdK) begin
               enrdK <= 1;
            end

            // Enable L_buff write (if it is off) and start pre-filter arithmetic for writting to L_buff
            if (buff_iterate > Kdelay) begin	// 3 clock wait [Kdelay - (Kdelay - 3)] to allow K_buff reading to catch up
               if (~enwrL) begin
                   enwrL <= 1;
               end
               K_diff_tdata <= s_axis_tdata - K_delay_tdata;	// Data to be written to L_buff, necessary to capture baseline
            end

            // Enable L_buff read (if it is off) after L_buff has written to Ldelay - 2 number of registers
            if (buff_iterate > Kdelay + Ldelay - 2 && ~enrdL) begin
		enrdL <= 1;
            end

	end else begin
            //Filter arithmetic
	    K_diff_tdata <= s_axis_tdata - K_delay_tdata;	// Subtractor 1
	    L_diff_tdata <= K_diff_tdata - L_delay_tdata;	// Subtractor 2
		  mult_tdata <= L_diff_tdata * mult_factor - L_diff_tdata>>>2;	// Multiplier
	    accu_tdata <= accu_tdata + L_diff_tdata;		// Accumulator 1
	    sum_tdata <= mult_tdata + accu_tdata;		// Adder
	    result_tdata <= result_tdata + sum_tdata;		// Accumulator 2
        end
    end
endmodule
