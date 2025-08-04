module spi_DUT;

reg MOSI;
reg SS_n;
reg clk;
reg rst_n;
wire MISO;


SPI_WRAPPER uut (MOSI,SS_n,clk,rst_n,MISO);

initial clk = 0;
always #5 clk = ~clk;

integer i;
initial begin
    rst_n = 0; SS_n = 1; MOSI = 0;
    $readmemh("memory.txt",uut.RAM.ram);
    #10
    rst_n = 1; 
    SS_n = 0; // start comm

	// Write Address Test Case
	#10
	MOSI = 0; // WRITE state
    #10
    MOSI = 0;
	#10
    MOSI = 0; // 00 cmd
    #10
	for(i = 0;i < 7;i = i + 1) begin
		MOSI = $random % 2;
		#10;
	end
	#10
	SS_n = 1; //stop comm

	// Write Data Test Case
	#10
    SS_n = 0; // start comm
    #10
	MOSI = 0; // WRITE state
	#10
    MOSI = 0;
    #10
	MOSI = 1; // 01 cmd
	#10
	for(i = 0;i < 7;i = i + 1) begin
		MOSI = $random % 2;
		#10;
	end
	#10
    SS_n = 1; // stop comm
    
	// Read Address Test Case
	#10
	SS_n = 0; // start comm
	#10
	MOSI = 1; // READ state
	#10
	MOSI = 1;
	#10
	MOSI = 0; // 10 cmd
	#10
	for(i = 0;i < 7;i = i + 1) begin
		MOSI = $random % 2;
		#10;
	end
    #10
	SS_n = 1; // stop comm

	// Read Data Test Case
	#10
	SS_n = 0; // start comm
	#10
	MOSI = 1; // READ state
	#10
	MOSI = 1;
	#10
	MOSI = 1; // 11 cmd
	for(i = 0;i < 7;i = i + 1) begin
		MOSI = $random % 2;
		#10;
	end

    #100
    SS_n = 1;
    
	#20
	$stop;
end

endmodule