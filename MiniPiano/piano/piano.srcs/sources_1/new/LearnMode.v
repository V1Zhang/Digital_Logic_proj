`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 19:20:15
// Design Name: 
// Module Name: LearnMode
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


module LearnMode(
input clk,rst_n,
input [6:0]note,
output speaker,
output s,
output reg [6:0]light
);
    

littlestar_learning learn(.clk(clk), .rst_n(rst_n), .note(note), .speaker(speaker), .s(s), .light(light));
endmodule
