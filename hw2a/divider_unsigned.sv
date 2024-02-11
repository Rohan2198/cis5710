/* INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ns

// quotient = dividend / divisor

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

    assign x = (m_remainder3 < i_divisor);

    assign o_quotient = (x) ? {i_quotient[30:0], 1'b0} : {i_quotient[30:0], 1'b1}; 
    assign o_remainder = (x) ? m_remainder3 : (m_remainder3 - i_divisor);
    assign o_dividend = {i_dividend[30:0], 1'b0};
endmodule

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

    wire [31:0] i_remainder;
    wire [31:0] i_quotient ;
    wire [31:0] remainder;
    wire [31:0] quotient ;
    wire [31:0] dividend ;   
    
    genvar i;

        for (i = 0; i < 32; i = i + 1) begin 
            divu_1iter d (
                .i_dividend(i_dividend),
                .i_divisor(i_divisor),
                .i_remainder(i_remainder),
                .i_quotient(i_quotient),
                .o_dividend(dividend),
                .o_remainder(remainder),
                .o_quotient(quotient)
            );
        
   end

    assign o_remainder = remainder;
    assign o_quotient = quotient;

endmodule
