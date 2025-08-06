module par_DUT;

reg Data_Valid;
reg [7:0] P_DATA;
reg PAR_TYPE;
wire par_bit;

parity_calc uut (Data_Valid, P_DATA,PAR_TYPE,par_bit);


initial begin
    Data_Valid = 0; P_DATA = 0; P_DATA = 8'b1010001; PAR_TYPE = 0;
    #10
    // Test even parity
    Data_Valid = 1;
    #10
    PAR_TYPE = 0;
    
    #10
    // Test odd parity
    PAR_TYPE = 1;

    #40
    $stop;
end


endmodule