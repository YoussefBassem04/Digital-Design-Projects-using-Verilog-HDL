module timer #(parameter BITS = 4)(
    input clk,rst_n,enable,
    input [BITS - 1:0] final_value,
    output done
);

reg [BITS - 1:0] counter;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) 
        counter <= 0;
    else if (enable)
        counter <= counter + 1;
    else 
        counter <= counter;
end

assign done = (counter == final_value);

endmodule