module df_sync #(parameter ADDR = 6)(
    input clk,rst_n,
    input [ADDR:0] d,
    output reg [ADDR:0] q
);

reg [ADDR:0] q1;

always @(posedge clk,negedge rst_n) begin
    if (!rst_n) begin
        q <= 0;
        q1 <= 0;
    end
    else begin
      q1 <= d;
      q <= q1;
    end

end


endmodule