module uart_DUT;

reg [7:0] P_DATA;
reg DATA_VALID;
reg PAR_EN, PAR_TYP;
reg clk, rst_n;
wire TX_OUT, Busy;

uart_tx uut (P_DATA,DATA_VALID,PAR_EN,PAR_TYP,clk,rst_n,TX_OUT,Busy);

localparam T = 2.5;

initial clk = 0;
always #(T / 2) clk = ~clk;

initial begin
    rst_n = 0; DATA_VALID = 0; PAR_EN = 0; PAR_TYP = 0; P_DATA = 8'b0;

    #10
    P_DATA = 8'b10101010;
    #10
    rst_n = 1;

    // Frame 1: Send 8'b10101010, no parity
    #10
    DATA_VALID = 1;
    PAR_EN = 0;
    #10 
    DATA_VALID = 0; // one clk cycle high

    
    #150
    
    // Frame 2: Send 8'b01001101 with odd parity
    rst_n = 0; DATA_VALID = 0; PAR_EN = 0; PAR_TYP = 0;
    #10;
    P_DATA = 8'b01001101;
    #10
    rst_n = 1;
    #10
    DATA_VALID = 1;
    PAR_EN = 1;
    PAR_TYP = 1;
    #5 DATA_VALID = 0;

    #100;
    $stop;
end

endmodule