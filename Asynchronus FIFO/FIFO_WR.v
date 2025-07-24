module fifo_wr #(parameter ADDR = 6)(
    input wclk,wrst_n,winc,
    input [ADDR:0] wq2_rptr, // Synchronized read pointer from the read domain
    output reg [ADDR - 1:0] waddr,
    output reg [ADDR:0] wptr,
    output wfull,wclken
);


assign wfull = (wptr[ADDR] != wq2_rptr[ADDR]) &&
               (wptr[ADDR - 1:0] == wq2_rptr[ADDR - 1:0]);

assign wclken = ~wfull & winc;
assign waddr = wptr;

always @(posedge wclk, negedge wrst_n) begin
    if (!wrst_n) begin
        waddr <= 0;
        wptr <= 0;
    end
    else if (wclken) begin
        wptr <= wptr + 1;
    end
    else 
        wptr <= wptr;
end

endmodule