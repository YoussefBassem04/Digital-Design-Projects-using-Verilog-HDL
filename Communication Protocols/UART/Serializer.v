module serializer(
    input [7:0] P_DATA,
    input ser_en, clk,
    output reg ser_done,
    output reg ser_data
);


integer counter;
reg [7:0] my_reg;
always @(posedge clk) begin
    if (!ser_en) begin
        ser_done <= 0;
        ser_data <= 0;
        counter <= 0;
        my_reg = P_DATA;
    end
    else begin
        ser_data <= my_reg[0];
        my_reg = my_reg >> 1;
        counter <=  counter + 1;
    end
end

always @(*) begin
    ser_done = (counter >= 8);

end

endmodule