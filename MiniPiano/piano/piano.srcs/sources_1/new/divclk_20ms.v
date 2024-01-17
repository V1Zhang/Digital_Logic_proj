`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 16:54:43
// Design Name: 
// Module Name: divclk_20ms
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


module divclk_20ms(
input clk,rst_n,
output reg clk_20ms
    );
    parameter period=2000;
    reg [31:0] cnt;
    always @(posedge clk,negedge rst_n )
    begin
        if (~rst_n) begin
            cnt<=0;
            clk_20ms<=0;
        end
        else
            if (cnt==((period>>1)-1))
            begin
                clk_20ms<=~clk_20ms;
                cnt<=0;
            end
            else begin
                cnt<=cnt+1;
            end 
    end
endmodule
