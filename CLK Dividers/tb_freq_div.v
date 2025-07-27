module freq_div_DUT;

parameter WIDTH = 3;
reg clk_ref,rst_n,clk_en;
reg [WIDTH - 1:0] div_ratio;
wire clk_out;


freq_div #(WIDTH) uut (clk_ref,rst_n,clk_en,div_ratio,clk_out);

initial clk_ref = 0;
always #5 clk_ref = ~clk_ref;

initial begin
    rst_n = 0; clk_en = 0; div_ratio = 0;
    @(posedge clk_ref);
    rst_n = 1;
    div_ratio = 6;
    #10
    clk_en = 1;
    #200
    $stop;
end


endmodule