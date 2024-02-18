`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);

           wire [3:0] g_mid;
           wire [3:0] p_mid;

   // Compute individual generate and propagate signals for each bit
   genvar i;
       for (i = 0; i < 4; i = i + 1) begin 
                  gp1 inst (.a(gin[i]), .b(pin[i]), .g(g_mid[i]), .p(p_mid[i]));
       end

   // Compute aggregate generate and propagate signals over the 4-bit window
           assign gout = g_mid[3] | (p_mid[3] & g_mid[2]) | (p_mid[2] & p_mid[1] & g_mid[1]) | (p_mid[2] & p_mid[1] & p_mid[0] & g_mid[0]) ; 
           assign pout = |p_mid;
           

   // Compute carry out for the low-order 3 bits
           assign cout[0] = g_mid[0] | (p_mid[0] & cin);
           assign cout[1] = g_mid[1] | (p_mid[1] & cout[0]);
           assign cout[2] = g_mid[2] | (p_mid[2] & cout[1]);
endmodule

module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);

   wire [7:0] g_intermediate;
   wire [7:0] p_intermediate;

   // Compute individual generate and propagate signals for each bit
   genvar i;
   generate
       for (i = 0; i < 8; i = i + 1) begin : gen_propagate_loop
           gp1 gp1_inst (.a(gin[i]), .b(pin[i]), .g(g_intermediate[i]), .p(p_intermediate[i]));
       end
   endgenerate

   // Compute aggregate generate and propagate signals over the 8-bit window
   assign gout = |g_intermediate;
   assign pout = |p_intermediate;

   // Compute carry out for the low-order 7 bits
   assign cout = {g_intermediate[0] & cin, g_intermediate[1], g_intermediate[2], g_intermediate[3],
                 g_intermediate[4], g_intermediate[5], g_intermediate[6]};

endmodule


module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   // TODO: your code here

endmodule
