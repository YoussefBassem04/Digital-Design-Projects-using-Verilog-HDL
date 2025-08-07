module serializer(
    input clk,
    input rst_n,          
    input ser_en,       
    input [7:0] P_DATA,     
    output reg ser_done,     
    output reg ser_data      
);

integer counter;        
reg [7:0] shift_reg;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= P_DATA;
        counter   <= 0;
        ser_data  <= 1'b1; // IDLE line
        ser_done  <= 1'b0;
    end
    else if (ser_en) begin
        ser_data  <= shift_reg[0];
        shift_reg <= shift_reg >> 1;
        counter   <= counter + 1;
        ser_done <= (counter >= 7);
    end
    else 
        shift_reg <= P_DATA;
end

endmodule
