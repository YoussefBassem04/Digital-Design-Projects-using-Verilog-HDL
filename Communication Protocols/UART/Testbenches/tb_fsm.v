module fsm_DUT;

reg clk, rst_n;
reg Data_Valid, PAR_EN, ser_done;
wire ser_en, busy;
wire [1:0] mux_sel;

fsm uut (
    .clk(clk),
    .rst_n(rst_n),
    .Data_Valid(Data_Valid),
    .PAR_EN(PAR_EN),
    .ser_done(ser_done),
    .ser_en(ser_en),
    .busy(busy),
    .mux_sel(mux_sel)
);


always #5 clk = ~clk;

initial begin
    $monitor("Time: %0t | State Outputs: ser_en=%b, busy=%b, mux_sel=%b", $time, ser_en, busy, mux_sel);

    // Initial values
    clk = 0;
    rst_n = 0;
    Data_Valid = 0;
    PAR_EN = 0;
    ser_done = 0;

    // Reset pulse
    #10 rst_n = 1;

    // Send frame without parity
    #10 Data_Valid = 1;
    #10 Data_Valid = 0;  // de-assert to simulate pulse

    // Wait for START bit to complete
    
    #20ser_done = 1; // End START
    #10 ser_done = 0;

    // SEND state
    repeat (8) @(posedge clk);
    ser_done = 1; // End SEND
    #10 ser_done = 0;

    // STOP state
    #20 ser_done = 1;
    #10 ser_done = 0;

    // Test again with parity enabled
    #30 Data_Valid = 1;
        PAR_EN = 1;
    #10 Data_Valid = 0;

    #20 ser_done = 1; // End START
    #10 ser_done = 0;
    repeat (8) @(posedge clk);

    ser_done = 1; // End SEND
    #10 ser_done = 0;

    #20 ser_done = 1; // End PARITY
    #10 ser_done = 0;

    #20 ser_done = 1; // End STOP
    #10 ser_done = 0;

    #50 
    $stop;
end

endmodule
