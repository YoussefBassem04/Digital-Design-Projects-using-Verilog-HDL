module clk_div_DUT;


reg clk_ref,rst_n,clk_en;
reg [7:0] div_ratio;
wire clk_out;


CLK_Division uut (clk_ref,rst_n,clk_en,div_ratio,clk_out);

initial clk_ref = 0;
always #5 clk_ref = ~clk_ref;

initial begin
    rst_n = 0; clk_en = 0; div_ratio = 0;
    @(posedge clk_ref);
    rst_n = 1;
    div_ratio = 3;
    #10
    clk_en = 1;
    #200
    $stop;
end


endmodule