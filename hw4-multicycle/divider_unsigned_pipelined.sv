/* INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned_pipelined (
    input wire clk, rst,
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

     // Define pipeline registers for stage 1
    reg  [31:0] remainder_reg_1;
    reg  [31:0] quotient_reg_1;
    reg  [31:0] dividend_reg_1;

    // Define pipeline registers for stage 2
    reg  [31:0] remainder_reg_2;
    reg  [31:0] quotient_reg_2;
    reg  [31:0] dividend_reg_2;

    // Instantiate divu_1iter modules for both pipeline stages in stage 1
    divu_1iter stage1_0 (
        .i_dividend(i_dividend), // Connect stage 1's dividend
        .i_divisor(i_divisor), // Connect common divisor input
        .i_remainder(32'b0), // Initial remainder for stage 1
        .i_quotient(32'b0), // Initial quotient for stage 1
        .o_dividend(dividend_reg_1), // Connect stage 1's dividend output
        .o_remainder(remainder_reg_1), // Connect stage 1's remainder output
        .o_quotient(quotient_reg_1) // Connect stage 1's quotient output
    );

    // Instantiate divu_1iter modules for both pipeline stages in stage 2
    divu_1iter stage2_0 (
        .i_dividend(dividend_reg_1), // Connect stage 1's dividend output
        .i_divisor(i_divisor), // Connect common divisor input
        .i_remainder(32'b0), // Initial remainder for stage 2
        .i_quotient(32'b0), // Initial quotient for stage 2
        .o_dividend(dividend_reg_2), // Connect stage 2's dividend output
        .o_remainder(remainder_reg_2), // Connect stage 2's remainder output
        .o_quotient(quotient_reg_2) // Connect stage 2's quotient output
    );

    // Output assignment (from the last stage of the pipeline)
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            o_remainder <= 0;
            o_quotient <= 0;
        end else begin
            o_remainder <= remainder_reg_2;
            o_quotient <= quotient_reg_2;
        end
    end

    // Input assignment (for the first stage of the pipeline)
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            remainder_reg_1 <= 0;
            quotient_reg_1 <= 0;
            dividend_reg_1 <= 0;
        end else begin
            remainder_reg_1 <= remainder_reg_2; // Pass data between stages
            quotient_reg_1 <= quotient_reg_2;
            dividend_reg_1 <= i_dividend;
        end
    end

    // Additional pipeline register updates
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            remainder_reg_2 <= 0;
            quotient_reg_2 <= 0;
            dividend_reg_2 <= 0;
        end else begin
            remainder_reg_2 <= remainder_reg_1; // Pass data between stages
            quotient_reg_2 <= quotient_reg_1;
            dividend_reg_2 <= dividend_reg_1;
        end
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

  // TODO: copy your code from HW2A here

endmodule
