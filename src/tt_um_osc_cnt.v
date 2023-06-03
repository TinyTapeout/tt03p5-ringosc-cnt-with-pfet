/*
 * tt_um_osc_cnt.v
 *
 * Ring oscillator with 64-bit counter
 *
 * Author: Uri Shaked
 */

`default_nettype none

module tt_um_osc_cnt #(
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
	wire cnt_reset = ui_in[7];
	wire [63:0] cnt_shifted = cnt >> cnt_shift;

	assign uo_out = cnt_shifted[7:0];

	genvar i;
	generate
		// Oscillator
		for (i = 0; i < OSC_LEN; i = i + 1) begin
			sky130_fd_sc_hd__inv_2 cnt_bit_I (
				.A     (osc[i]),
				.Y     (osc[i > 0 ? i - 1 : OSC_LEN - 1])
			);
		end

		// Counter
		for (i=0; i<64; i=i+1) begin
			sky130_fd_sc_hd__dfrbp_2 cnt_bit_I (
				.D     (cnt_n[i]),
				.Q     (cnt[i]),
				.Q_N   (cnt_n[i]),
				.CLK   (cnt_clk[i]),
				.RESET_B (!cnt_reset)
			);
		end
	endgenerate

endmodule // tt_um_osc_cnt
