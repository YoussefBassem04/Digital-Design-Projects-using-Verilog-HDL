module singleport_RAM #(parameter DEPTH = 256, ADDR_SIZE = 8)(
    input clk, rst_n,
    input [9:0] din,
    input rx_valid,
    output reg [7:0] dout,
    output reg tx_valid
);

reg [ADDR_SIZE - 1:0] ram [0:DEPTH - 1];

reg [ADDR_SIZE - 1:0] w_addr,r_addr;


always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        dout <= 0;
        tx_valid <= 0;
        w_addr <= 0;
        r_addr <= 0;
    end
    else begin
        tx_valid <= ((din[9:8] == 2'b11) & rx_valid);
        if (rx_valid) begin
            case (din[9:8])
                2'b00: w_addr <= din[7:0];
                2'b01: ram[w_addr] <= din[7:0];
                2'b10: r_addr <=  din[7:0];
                2'b11: dout <= ram[r_addr];
                default: dout <= 0;
            endcase
        end
    end
end

endmodule