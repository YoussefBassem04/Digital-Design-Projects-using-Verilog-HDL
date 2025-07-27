module pwm_DUT;

parameter R = 8;
parameter TIMER_BITS = 8;

reg [R - 1:0] duty_cycle;
reg [TIMER_BITS - 1:0] final_value;
reg clk_in,rst_n;
wire pwm_out;

pwm #(R,TIMER_BITS) uut (duty_cycle,final_value,clk_in,rst_n,pwm_out);
localparam T = 10;



// Generating a clk signal
initial clk_in = 0;
always #(T/2) clk_in = ~clk_in;


initial
begin
    // issue a quick reset for 2 ns
    rst_n = 1'b0;
    #2  
    rst_n = 1'b1;
    duty_cycle = 0.25 * (2**R);
    final_value = 8'd194; // t_pwm = 0.5 ms
    
    repeat(2 * 2**R * final_value) @(negedge clk_in);
    duty_cycle = 0.50 * (2**R);

    repeat(2 * 2**R * final_value) @(negedge clk_in);
    duty_cycle = 0.75 * (2**R);
        
    #(7 * 2**R * T * 200) 
    #1000
    $stop;
end 


endmodule