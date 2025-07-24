module fifo_mem #(parameter DATA_WIDTH = 8,ADDR = 6)(
    input [DATA_WIDTH-1:0] wdata,
    input [ADDR-1:0] waddr, raddr,
    input wclken,wclk,rclken,rclk,
    output reg [DATA_WIDTH-1:0] rdata
);

reg [DATA_WIDTH - 1:0] fifo [0:2**ADDR - 1];

// write operation
always @(posedge wclk) begin
    if (wclken) 
        fifo[waddr] <= wdata;
    else
        rdata <= rdata;

end


// read operation
always @(posedge rclk) begin
    if (rclken)
        rdata <= fifo[raddr];
    else
        rdata <= rdata;
end

endmodule