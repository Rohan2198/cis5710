/* INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
    genvar i;
    wire [31:0] i_remainder, wire [31:0] i_quotient, wire [31:0] o_dividend;
        for(i =0; i<32; i = i+1)begin
        divu_1iter d (.i_dividend(i_dividend),.i_divisor(i_divisor),i_remainder,
                        i_quotient,o_dividend,.o_remainder(o_remainder),.o_quotient(o_quotient));
        end
endmodule


module divu_1iter (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    input  wire [31:0] i_remainder,
    input  wire [31:0] i_quotient,
    output wire [31:0] o_dividend,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
    wire [31:0] m_remainder = 32'b0;
    always_comb begin
        m_remainder = (i_remainder << 1) | ((i_dividend >> 31) & 0x1);
        if (m_remainder < i_divisor) begin
            o_quotient = (i_quotient << 1);
        end
        else begin
            o_quotient = (i_quotient << 1) | 0x1;
            o_remainder = m_remainder - i_divisor;
        end
        o_dividend = i_dividend << 1;
    end
endmodule
