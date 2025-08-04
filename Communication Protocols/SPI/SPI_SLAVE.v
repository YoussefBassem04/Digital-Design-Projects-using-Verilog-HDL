module spi_slave(
    input MOSI,
    input tx_valid,
    input [7:0] tx_data,
    input ss_n,
    input rst_n, clk,
    output reg MISO,
    output reg rx_valid,
    output reg [9:0] rx_data
);

// fsm using gray encoding
localparam [3:0] IDLE      = 3'b000,
                 CHK_CMD   = 3'b001,
                 WRITE     = 3'b011,
                 READ_ADD  = 3'b010,
                 READ_DATA = 3'b110;

reg [3:0] ps, ns;
reg read_data;
reg [3:0] write_cnt, read_cnt;
// write address

// state memory
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        ps <= IDLE;
        read_data <= 0;
        rx_data <= 0;
    end
    else
        ps <= ns;
end

// transition logic
always @(*) begin
    case (ps)
        IDLE: ns = (ss_n == 0)? CHK_CMD : IDLE;
        CHK_CMD: begin
            if (!ss_n)
                ns = (MOSI)? ((read_data)? READ_DATA : READ_ADD) : WRITE;
            else
                ns = IDLE;
        end 
        WRITE: ns = (ss_n)? IDLE : WRITE;
        READ_ADD: ns = (ss_n)? IDLE : READ_ADD;
        READ_DATA: ns = (ss_n)? IDLE: READ_DATA;
        default: ns = IDLE;
    endcase
end


// output logic
always @(posedge clk) begin
    case (ps)
        IDLE: {write_cnt,read_cnt} = 0;
        WRITE: begin
            if (write_cnt < 10) begin
                rx_data <= {rx_data[8:0], MOSI};
                write_cnt <= write_cnt + 1;
            end
        end 
        READ_ADD: begin
            if (write_cnt < 10) begin
                read_data <= 1;
                rx_data <= {rx_data[8:0], MOSI};
                write_cnt <= write_cnt + 1;
            end
        end
        READ_DATA: begin
            if (write_cnt < 10) begin
                rx_data <= {rx_data[8:0], MOSI};
                write_cnt <= write_cnt + 1;
            end
            if (tx_valid) begin
                MISO <= tx_data[8 - read_cnt];
                read_cnt <= read_cnt + 1;
            end

        end
        default: {write_cnt,read_cnt} = 0;
    endcase
end

// rx_valid logic
always @(*) begin
    if ((ps == WRITE || ps == READ_ADD || ps == READ_DATA) && write_cnt >= 10)
        rx_valid = 1;
    else
        rx_valid = 0;
end

endmodule