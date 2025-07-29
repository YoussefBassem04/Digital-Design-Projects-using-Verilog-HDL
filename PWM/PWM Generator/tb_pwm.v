module pwm_DUT;

reg clk;
reg increase_duty;
reg decrease_duty;
wire pwm_out;

pwm_generator uut(
    .clk(clk),
    .decrease_duty(decrease_duty),
    .increase_duty(increase_duty),
    .pwm_out(pwm_out)
);

// 100MHz clock
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period
end

// Stimulus
initial begin
    increase_duty = 0;
    decrease_duty = 0;

    #100;

    // Step-by-step increase
    pulse_increase(); // to 60%
    #200;
    pulse_increase(); // to 70%
    #200;
    pulse_increase(); // to 80%
    #200;
    pulse_increase(); // to 90%

    #500;

    // Decrease duty
    pulse_decrease(); // to 80%
    #200;
    pulse_decrease(); // to 70%
    
    #200;
    $stop;
end

// Pulse increase_duty for 1 clock cycle
task pulse_increase;
begin
    @(posedge clk);
    increase_duty = 1;
    @(posedge clk);
    increase_duty = 0;
end
endtask

// Pulse decrease_duty for 1 clock cycle
task pulse_decrease;
begin
    @(posedge clk);
    decrease_duty = 1;
    @(posedge clk);
    decrease_duty = 0;
end
endtask

endmodule
