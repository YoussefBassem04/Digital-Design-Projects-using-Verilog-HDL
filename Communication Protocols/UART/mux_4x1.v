module mux_4to1(
    input [3:0] I,
    input [1:0] mux_sel,
    output Y
);

assign Y = I[mux_sel];

endmodule