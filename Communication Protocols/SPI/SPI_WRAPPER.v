module SPI_WRAPPER(
    input MOSI,
    input ss_n,
    input clk,
    input rst_n,
    output MISO
);

wire [9:0] rx_data;
wire [7:0] tx_data;
wire rx_valid, tx_valid;

spi_slave SPI (
    MOSI, tx_valid, tx_data, ss_n,rst_n,clk,MISO,rx_valid,rx_data
);

singleport_RAM RAM (
    clk,rst_n, rx_data,rx_valid, tx_data,tx_valid
);

endmodule