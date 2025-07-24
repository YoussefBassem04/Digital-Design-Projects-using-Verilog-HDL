module async_fifo #(parameter DATA_WIDTH = 8,ADDR = 6)(
    input wclk,w_rst,w_inc,
    input rclk,r_rst,r_inc,
    input [DATA_WIDTH - 1:0] WR_DATA,
    output [DATA_WIDTH - 1:0] RD_DATA,
    output EMPTY,FULL
);

wire [ADDR:0] rptr,wptr;
wire [ADDR:0] wq2_rptr,rq2_wptr;
wire [ADDR - 1:0] waddr,raddr;
wire wclken,rclken;


df_sync #(ADDR) wr_ff (
    wclk,w_rst,rptr,wq2_rptr
);

df_sync #(ADDR) rd_ff (
    rclk,r_rst,wptr,rq2_wptr
);


fifo_wr #(ADDR) wr (
    wclk,w_rst,w_inc,wq2_rptr,waddr,wptr,FULL,wclken
);

fifo_rd #(ADDR) rd (
    rclk,r_rst,r_inc,rq2_wptr,raddr,rptr,EMPTY,rclken
);

fifo_mem #(DATA_WIDTH,ADDR) main_mem (
    WR_DATA,waddr,raddr,wclken,wclk,rclken,rclk,RD_DATA
);

endmodule