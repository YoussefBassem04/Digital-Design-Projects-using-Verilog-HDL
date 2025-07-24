module fifo_rd #(parameter ADDR = 6)(
    input rclk,rrst_n,rinc,
    input [ADDR:0] rq2_wptr, // Synchronized write pointer from the write domain
    output reg [ADDR - 1:0] raddr,
    output reg [ADDR:0] rptr,
    output rempty,rclken
);

assign rempty = (rptr == rq2_wptr);

assign rclken = rinc & ~rempty;
assign raddr = rptr;

always @(posedge rclk, negedge rrst_n) begin
    if (!rrst_n) begin
        raddr <= 0;
        rptr <=0;
    end
    else if (rclken)
        rptr <= rptr + 1;
    else
        rptr <= rptr;
end

endmodule