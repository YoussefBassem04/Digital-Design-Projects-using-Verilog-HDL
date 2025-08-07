module ser_DUT;

reg [7:0] P_DATA;
reg ser_en, clk;
wire ser_done;
wire ser_data;


serializer uut (P_DATA,ser_en,clk,ser_done,ser_data);


initial clk = 0;
always #5 clk = ~clk;

initial begin
    P_DATA = 0; ser_en = 0;
    #10
    P_DATA = 8'h8f;
    #10
    ser_en = 1;
    repeat (10) @(posedge clk);
    ser_en = 0;
    #20
    P_DATA = 8'h9e;
    #10
    ser_en = 1;
    repeat (10) @(posedge clk);
    #40
    $stop;
end

endmodule