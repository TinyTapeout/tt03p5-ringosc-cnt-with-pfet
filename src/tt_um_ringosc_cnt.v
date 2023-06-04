/*
 * tt_um_ringosc_cnt.v
 *
 * Ring oscillator with 64-bit counter
 *
 * Author: Uri Shaked
 */

`default_nettype none

module tt_um_ringosc_cnt_pfet #(
	parameter integer OSC_LEN = 13
)
(
	input  wire [7:0] ui_in,	// Dedicated inputs
	output wire [7:0] uo_out,	// Dedicated outputs
	input  wire [7:0] uio_in,	// IOs: Input path
	output wire [7:0] uio_out,	// IOs: Output path
	output wire [7:0] uio_oe,	// IOs: Enable path (active high: 0=input, 1=output)
	input  wire       ena,
	input  wire       clk,
	input  wire       rst_n
);

	wire [OSC_LEN-1:0] osc;

	wire [63:0] cnt_n;
	wire [63:0] cnt;
	wire [63:0] cnt_clk = { cnt_n[62:0], osc[0] };

	wire [5:0] cnt_shift = ui_in[5:0];
	wire cnt_stop = ui_in[6];
	wire cnt_reset = ui_in[7];
	wire [63:0] cnt_shifted = cnt >> cnt_shift;

	assign uo_out = cnt_shifted[7:0];

	genvar i;
	generate
		// Oscillator
		for (i = 0; i < OSC_LEN; i = i + 1) begin: ringosc
			wire y;
			if (i == 0)
				assign y = cnt_stop ? 0 : osc[OSC_LEN - 1];
			else
				assign y = osc[i - 1];
			
			tt_prim_inv inv (
				.a (y),
				.y (osc[i])
			);
		end

		// Counter
		for (i=0; i<64; i=i+1) begin: counter
			tt_prim_dfrbp cnt_bit_I (
				.d     (cnt_n[i]),
				.q     (cnt[i]),
				.q_n   (cnt_n[i]),
				.clk   (cnt_clk[i]),
				.rst_n (!cnt_reset)
			);
		end
	endgenerate

endmodule // tt_um_osc_cnt
