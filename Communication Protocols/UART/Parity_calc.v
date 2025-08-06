module parity_calc(
    input Data_Valid,
    input [7:0] P_DATA,
    input PAR_TYPE,
    output reg par_bit
);


always @(*) begin
    if (!Data_Valid) 
        par_bit = 0;
    else 
        par_bit = (PAR_TYPE)? ~(^P_DATA) : (^P_DATA);
end

endmodule