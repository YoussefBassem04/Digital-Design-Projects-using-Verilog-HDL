module async_fifo_DUT;

parameter DATA_WIDTH = 8,ADDR = 6;

reg wclk,w_rst,w_inc;
reg rclk,r_rst,r_inc;
reg [DATA_WIDTH - 1:0] WR_DATA;
wire [DATA_WIDTH - 1:0] RD_DATA;
wire EMPTY,FULL;


async_fifo #(DATA_WIDTH,ADDR) uut (
    wclk,w_rst,w_inc,rclk,r_rst,r_inc,WR_DATA,RD_DATA,EMPTY,FULL
);

// Reading frequency: 40 MHz
localparam T_rd = 25;
initial rclk = 0;
always #(T_rd / 2) rclk = ~rclk;

// Writing frequency: 100 MHz
localparam T_wr = 10;
initial wclk = 0;
always #(T_wr / 2) wclk = ~wclk;

integer i;
reg [7:0] test_data [0:8]; // 9 bytes

initial begin
    
    for (i = 0; i < 9; i = i + 1)
        test_data[i] = 8'hA0 + i;

    WR_DATA = 0;
    w_rst = 0; r_rst = 0;
    #20;
    w_rst = 1; r_rst = 1;
    
    for (i = 0; i < 9; i = i + 1) begin
        @(negedge wclk);
        w_inc = 1;
        WR_DATA = test_data[i];
        @(negedge wclk);
        w_inc = 0;
        $display("Time %0t: WRITE -> Data = %h | FULL = %b", $time, WR_DATA, FULL);
    end
end


initial begin
    #40; 
    forever begin
        @(negedge rclk);
        if (!EMPTY)
            r_inc = 1;
        else
            r_inc = 0;

        @(posedge rclk);
        if (r_inc)
            $display("Time %0t: READ -> Data = %h | EMPTY = %b", $time, RD_DATA, EMPTY);
    end
end

initial #1000 $stop;



endmodule