module pwm_generator(
    input clk, decrease_duty,increase_duty,
    output pwm_out
);


reg [3:0] duty_cycle = 5; // 50% duty cycle
reg [3:0] pwm_counter = 0;
reg [3:0] Q_reg;

// vary the duty cycle
always @(posedge clk) begin
    if (increase_duty && duty_cycle < 9) begin
        duty_cycle <= duty_cycle + 1; // increase duty cycle by 10%
    end
    else if (decrease_duty && duty_cycle > 0) begin
        duty_cycle <= duty_cycle - 1; // decrease duty cycle by 10%
    end
end

// Create 10MHz PWM signal with variable duty cycle controlled by 2 buttons
always @(posedge clk) begin
    if (pwm_counter >= 9) 
        pwm_counter <= 0;
    else
        pwm_counter <= pwm_counter + 1;
end

always @(posedge clk) begin
    Q_reg <= (pwm_counter < duty_cycle);
end

assign pwm_out = Q_reg;

endmodule