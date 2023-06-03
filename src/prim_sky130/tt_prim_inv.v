`default_nettype none

module tt_prim_inv (
	input  wire a,
  output wire y
);

  sky130_fd_sc_hd__inv_2 cnt_bit_I (
    .A     (a),
    .Y     (y)
  );

endmodule // tt_prim_inv
