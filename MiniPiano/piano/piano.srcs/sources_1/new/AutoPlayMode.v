`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 15:47:59
// Design Name: 
// Module Name: AutoPlayMode
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


module AutoPlayMode(
input clk,
input key1,//up to choose other song
input key2,//down to choose other song
input rst,//reset 
input key,
output [3:0] segs,
output [7:0] seg_out,
output reg [6:0]light,
output reg speaker,
output s
) ;
assign s = 1'b0;
reg [3:0] cnt;//reprensent the current song number
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
            begin 
            cnt<=4'b0001;
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

wire [6:0]song1_light;
wire song1_speaker;
wire song1_s;
wire [6:0]song2_light;
wire song2_speaker;
wire song2_s;
wire [6:0]song3_light;
wire song3_speaker;
wire song3_s;


LittleStar song1(.clk(clk), .rst_n(rst), .key(key), .light(song1_light), .reset1(key1), .reset2(key2), .speaker(song1_speaker), .s(song1_s));
HappyBirthday song2(.clk(clk), .rst_n(rst), .key(key), .light(song2_light), .reset1(key1), .reset2(key2), .speaker(song2_speaker), .s(song2_s));
Spring song3(.clk(clk), .rst_n(rst), .key(key), .light(song3_light), .reset1(key1), .reset2(key2), .speaker(song3_speaker), .s(song3_s));

always @* begin
    case(cnt)
    4'b0001: begin
        speaker=song1_speaker;
        light=song1_light;
    end
    4'b0010:begin
        speaker=song2_speaker;
        light=song2_light;
    end
    4'b0011:begin
        speaker=song3_speaker;
        light=song3_light;
    end
    endcase
end

endmodule
