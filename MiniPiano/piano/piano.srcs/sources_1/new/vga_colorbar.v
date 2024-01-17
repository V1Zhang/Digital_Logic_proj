`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/31 01:56:38
// Design Name: 
// Module Name: vga_colorbar
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_colorbar (     
input clock,
input rst,
output wire hsync,
output wire vsync,
output wire [3:0] red,
output wire [3:0] green,
output wire [3:0] blue
    );

    wire vga_clk;
    dcm_25m clk_25m(
    .clk_in1(clock),
    .reset(rst),
    .clk_out1(vga_clk)
    );

    VGAcontroller vga(
    .clock(vga_clk),
    .rst(rst),
    .red(red),
    .green(green),
    .blue(blue),
    .hsync(hsync),
    .vsync(vsync)   );

    endmodule
