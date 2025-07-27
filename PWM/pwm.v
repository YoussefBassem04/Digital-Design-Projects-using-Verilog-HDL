module pwm #(parameter R = 8, TIMER_BITS = 15)(
    input [R - 1:0] duty_cycle,
    input [TIMER_BITS - 1:0] final_value,
    input clk_in,rst_n,
    output pwm_out
);

reg [R - 1:0] counter;
wire tick;
reg Q_reg;

timer #(TIMER_BITS) timer0 (
    .clk(clk_in),
    .rst_n(rst_n),
    .enable(1'b1),
    .final_value(final_value),
    .done(tick)
);

always @(posedge clk_in,negedge rst_n) begin
   if (!rst_n) 
        counter <= 0;
   else if (tick)
        counter <= counter + 1;
   else 
        counter <= counter;
end

always @(posedge clk_in) begin
    Q_reg <= (counter < duty_cycle);
end

assign pwm_out = Q_reg;

endmodule