`timescale 1 ns / 1 ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Samuel LeRose
// 
// Create Date: June 2023
// Design Name: 
// Module Name: ring_buffer
// Project Name: Trapezoidal Filter
// Target Devices: Red Pitaya STEMlab 125-14
// Tool Versions: 
// Description: Provides a read/write memory storage mechanism utilizing bit overflow.
// 		Also known as a ring buffer: https://en.wikipedia.org/wiki/Circular_buffer
// Dependencies: N/A
// 
// Revision: v1.0
// 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ring_buffer #
(
  parameter integer AXIS_TDATA_WIDTH = 16,
  parameter integer BUFFER_LENGTH = 256     // Length of ring buffer, adjust to specific needs, preferably a power of 2
						                    // kdelay + ldelay may not exceed BUFFER_LENGTH - 1
)
(
  input clk,
  input enrd,
  input enwr,
  input [8:0] delay,
  input signed [AXIS_TDATA_WIDTH-1:0] wr_data,
  output signed [AXIS_TDATA_WIDTH-1:0] rd_data
);

  // Ring buffer with BUFFER_LENGTH addressable locations, each location being a register of width AXIS_TDATA_WIDTH
  reg [AXIS_TDATA_WIDTH-1:0] ring_buff [0:BUFFER_LENGTH - 1];
  reg [AXIS_TDATA_WIDTH-1:0] rd_reg;			// Register to hold read data for output assignment

  reg [$clog2(BUFFER_LENGTH)-1:0] wr_ptr = 0;		// Pointer to specify writing location in ring_buff
  reg [$clog2(BUFFER_LENGTH)-1:0] rd_ptr;		// Pointer to specify reading location in ring_buff

  assign rd_data = rd_reg;

  always @ (posedge clk) begin
      if (enwr) begin
        // Write handling
        ring_buff[wr_ptr] <= wr_data;	// Write data at ptr
        wr_ptr <= wr_ptr + 1;		// Iterate ptr
      end

      if (enrd) begin
        // Read handling
        rd_ptr <= wr_ptr - delay + 2;	// Set read pointer, add 2 to remove inherient delays with cycles
        rd_reg <= ring_buff[rd_ptr];	// Read data at delay_ptr 
      end
  end

endmodule
