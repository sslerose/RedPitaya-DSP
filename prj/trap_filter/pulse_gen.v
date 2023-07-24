`timescale 1ns / 1ps
//Generates 1 clock cycle pulse on positive edge of trigger
module pulse_gen #
(
    parameter integer OUTPUT_WIDTH = 1
)
(
    input wire clk,
    input wire trigger,
    output wire pulse
);
    reg [OUTPUT_WIDTH - 1 : 0] last;
    reg [OUTPUT_WIDTH - 1 : 0] pulse_reg;
    
    always @ (posedge clk) begin
        last <= trigger;
        if (trigger & ~last)
            pulse_reg <= 1;
        else
            pulse_reg <= 0;
    end

    assign pulse = pulse_reg;

endmodule
