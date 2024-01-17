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
input clk,rst,
input [6:0]note,
input key1,
input key2,
input confirm,
output speaker,
output s,
output wire [6:0]light,
output [7:0] seg_out,
output [7:0] seg_out2,
output [3:0] segs,
output seg_en2
);
    

littlestar_learning learn(.clk(clk), .rst(rst), .note(note), .key1(key1), .key2(key2), .key_confirm(confirm),.speaker(speaker), .s(s), .light(light), .seg_out(seg_out), .seg_out2(seg_out2), .segs(segs), .seg_en2(seg_en2));
endmodule
