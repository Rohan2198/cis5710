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
    wire [31:0] i_remainder;
    wire [31:0] i_quotient; 
    wire [31:0] o_dividend;
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
    wire [31:0] m_remainder;
    wire [31:0] m_remainder1;
    wire [31:0] m_remainder3;
    wire [31:0] m_remainder2;
    wire x;

    assign m_remainder = {i_remainder[30:0], 1'b0};
    assign m_remainder1 = {31'b0, i_dividend[31]};
    assign m_remainder2 = m_remainder1 & {31'b0, 1'b1};
    assign m_remainder3 = m_remainder | m_remainder2;

    always_comb begin
        if (m_remainder < i_divisor)
            x = 1'b1;
        else
            x = 1'b0;
    end

    assign o_quotient = (x == 1'b1) ? {i_quotient, 1'b0} : {i_quotient, 1'b1}; 
    assign o_remainder = (x == 1'b1) ? m_remainder3 : (m_remainder3 - i_divisor);
    assign o_dividend = i_dividend << 1;
endmodule
