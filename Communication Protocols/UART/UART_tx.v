module uart_tx(
    input [7:0] P_DATA,
    input DATA_VALID,
    input PAR_EN, PAR_TYP,
    input clk, rst_n,
    output TX_OUT, Busy
);

wire ser_en, ser_done, ser_data, par_bit;
wire [1:0] mux_sel;

serializer ser (clk,rst_n,ser_en,P_DATA,ser_done,ser_data);

parity_calc par (PAR_EN, P_DATA, PAR_TYP, par_bit);

fsm FSM (DATA_VALID,PAR_EN,ser_done,clk,rst_n,ser_en, Busy, mux_sel);

mux_4to1 mux ({par_bit, ser_data, 1'b1, 1'b0},mux_sel,TX_OUT);

endmodule