`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input [5:0] shift_i,
    input stop_i,
    input reset_i,
    output [7:0] cnt_o
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // instantiate the DUT
    tt_um_ringosc_cnt_pfet osc(
        `ifdef GL_TEST
            .vccd1( 1'b1),
            .vssd1( 1'b0),
        `endif
        .ui_in  ({reset_i, stop_i, shift_i}),
        .uo_out (cnt_o),
        .uio_in (8'b0),
        .ena    (1'b0),
        .clk    (1'b0),
        .rst_n  (1'b0)
    );

endmodule


