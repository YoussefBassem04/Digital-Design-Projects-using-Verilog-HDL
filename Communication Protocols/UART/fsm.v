module fsm (
    input Data_Valid,
    input PAR_EN,
    input ser_done,
    input clk, rst_n,
    output reg ser_en,
    output reg busy,
    output reg [1:0] mux_sel
);

localparam [2:0] IDLE   = 3'b000,
                 START  = 3'b001,
                 SEND   = 3'b011,
                 PARITY = 3'b010,
                 STOP   = 3'b110;

reg [2:0] ps, ns;

// state memory
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ps <= IDLE;
    end
    else
        ps <= ns;
end

// transion and output logic
always @(*) begin
    ns = ps;
    ser_en = 0;
    busy = 0;
    mux_sel = 2'b10;
    case (ps)
        IDLE: begin
            if (Data_Valid) begin
                ns = START;
                mux_sel = 2'b00; // start bit
                busy = 1;
                ser_en = 1;
            end
        end

        START: begin
            busy = 1;
            mux_sel = 2'b10;
            if (ser_done) begin
                ns = SEND;
            end else begin
                ser_en = 1;
            end
        end

        SEND: begin
            busy = 1;
            mux_sel = 2'b10; // serial data
            if (ser_done) 
                ns = PAR_EN ? PARITY : STOP;
            else 
                ser_en = 1;
            
        end

        PARITY: begin
            busy = 1;
            mux_sel = 2'b11;
            if (ser_done)
                ns = STOP;
            else
                ser_en = 1;
        end

        STOP: begin
            busy = 1;
            mux_sel = 2'b01;
            if (ser_done)
                ns = IDLE;
            else
                ser_en = 1;
        end

        default: ns = IDLE;
    endcase
end

endmodule
