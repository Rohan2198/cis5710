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

module divider_unsigned_pipelined (
    input wire clk, rst,
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient

);

    logic [31:0] remainder [33];
    logic [31:0] quotient [33] ;
    logic [31:0] dividend [33]; 
    logic [31:0] remainderi ;
    logic [31:0] quotienti  ;
    logic [31:0] dividendi ;     
    logic [31:0] divisori;
    assign dividend [0] = i_dividend;
    assign quotient [0] = 32'b0;
    assign remainder [0] = 32'b0;
    genvar i;
    for (i = 0; i < 32; i = i + 1) begin : abc
        if (i==16) begin : ghj
            divu_1iter d1(
            .i_dividend(dividendi),
            .i_divisor(divisori),
            .i_remainder(remainderi),
            .i_quotient(quotienti),
            .o_dividend(dividend[i+1]),
            .o_remainder(remainder[i+1]),
            .o_quotient(quotient[i+1])
            );
        end else begin : xyz
            divu_1iter d2(
                .i_dividend(dividend[i]),
                .i_divisor((i<16)?i_divisor: divisori),
                .i_remainder(remainder[i]),
                .i_quotient(quotient[i]),
                .o_dividend(dividend[i+1]),
                .o_remainder(remainder[i+1]),
                .o_quotient(quotient[i+1])
            );
        end
        if (i==15) begin : def
            always_ff @ (posedge clk) begin
                if(rst) begin : bnm
                dividendi <= 32'b0;
                remainderi <= 32'b0;
                quotienti <= 32'b0;
                divisori <= 32'b0;
                end else begin
                dividendi <= dividend[i+1];
                remainderi <= remainder[i+1];
                quotienti <= quotient[i+1];
                divisori <= i_divisor;
                end
            end
        end
    end

    assign o_remainder = remainder[32];
    assign o_quotient = quotient[32];

endmodule
