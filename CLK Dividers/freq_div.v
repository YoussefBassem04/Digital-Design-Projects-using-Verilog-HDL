module freq_div #(parameter WIDTH = 2)(
    input clk_ref,rst_n,clk_en,
    input [WIDTH - 1:0] div_ratio,
    output reg clk_out
);
wire clk_En_in;
reg [WIDTH - 1:0] counter;
assign clk_En_in = clk_en && (div_ratio != 8'b0) && (div_ratio != 8'b1) ;
assign clk_out = (div_ratio & 1'b1)? counter[WIDTH - 1] : counter[div_ratio/2 - 1];

always @(posedge clk_ref, negedge rst_n) begin
    if (!rst_n || (counter == div_ratio - 1)) begin
        counter <= 0;
        clk_out <= 0;
    end
    else if (clk_En_in) begin
        counter <= counter + 1;
    end

end

endmodule