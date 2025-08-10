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
                 PARITY = 3'b011,
                 STOP   = 3'b010;
   

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
            else
                ns = IDLE;
        end

        START: begin
            busy = 1;
            mux_sel = 2'b10; // Send data
            if (ser_done) begin
                ns = PAR_EN? PARITY : STOP;
            end else begin
                ser_en = 1;
                ns = START;
            end
        end

        PARITY: begin
            busy = 1;
            mux_sel = 2'b11; // parity bit
            
            if (ser_done)
                ns = STOP;
            else
                ser_en = 1;
        end

        STOP: begin
            busy = 0;
            mux_sel = 2'b01; //stop bit
            if (ser_done)
                ns = IDLE;
            else
                ser_en = 1;
        end

        default: ns = IDLE;
    endcase
end

endmodule
