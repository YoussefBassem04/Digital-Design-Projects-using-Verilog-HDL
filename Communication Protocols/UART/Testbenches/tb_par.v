module par_DUT;

reg PAR_EN;
reg [7:0] P_DATA;
reg PAR_TYPE;
wire par_bit;

parity_calc uut (PAR_EN, P_DATA,PAR_TYPE,par_bit);


initial begin
    PAR_EN = 0; P_DATA = 0; P_DATA = 8'b1010001; PAR_TYPE = 0;
    #10
    // Test even parity
    PAR_EN = 1;
    #10
    PAR_TYPE = 0;
    
    #10
    // Test odd parity
    PAR_TYPE = 1;

    #40
    $stop;
end


endmodule