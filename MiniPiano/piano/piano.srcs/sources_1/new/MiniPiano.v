`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 14:43:36
// Design Name: 
// Module Name: MiniPiano
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


module MiniPiano(
input clk,
input key1,//up to choose other mode
input key2,//down to choose other mode
input rst,//reset 
output [3:0] segs,
output [7:0] seg_out
) ;
reg [3:0] cnt;//reprensent the current mode number
//the function of key to change the ptone
wire clk_20ms;
wire key1_pulse;
wire key2_pulse;
divclk_20ms div(clk,rst,clk_20ms);
debounce_button b1(clk_20ms,rst,key1,key1_pulse);
debounce_button b2(clk_20ms,rst,key2,key2_pulse);
reg pre_pulse1;
reg now_pulse1;
reg pre_pulse2;
reg now_pulse2;
always @(posedge clk or negedge rst)
    begin 
        if (!rst)
            begin cnt<=4'b0001;
            pre_pulse1<=1'b0;
            now_pulse1<=1'b0;
            pre_pulse2<=1'b0;
            now_pulse2<=1'b0;
            end
        else 
        begin
            pre_pulse1<=now_pulse1;
            now_pulse1<=key1_pulse;
            pre_pulse2<=now_pulse2;
            now_pulse2<=key2_pulse;
           

           if(~pre_pulse1 & now_pulse1)
           begin
           if(cnt==4'b0011) cnt<=4'b0001; 
           else cnt<=cnt+4'b1;
           end 
                        
           else if(~pre_pulse2 & now_pulse2)
           begin
           if(cnt==4'b0001) cnt<=4'b0011; 
           else cnt<=cnt-4'b1;
           end 
            
           else cnt<=cnt;
        end  
    end
scan_seg three_seg(.rst(rst), .clk(clk), .in3(4'b1010), .in2(4'b1011), .in1(cnt), .in0(4'b1111), .segs(segs), .seg_out(seg_out));

    
endmodule
