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
output reg s,

output wire vga_hsync,
output wire vga_vsync,
output wire [7:0] vga_red,
output wire [7:0] vga_green,
output wire [7:0] vga_blue,
output wire vga_blank,
output wire vga_sync,
output wire vga_blank_n
) ;
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

reg [6:0]song_light;

always @(posedge clk or negedge rst)
    begin 
        if (!rst)
            begin 
            cnt<=4'b0001;
            pre_pulse1<=1'b0;
            now_pulse1<=1'b0;
            pre_pulse2<=1'b0;
            now_pulse2<=1'b0;
            light <= 7'b0000000;
            end
        else 
        begin
            pre_pulse1<=now_pulse1;
            now_pulse1<=key1_pulse;
            pre_pulse2<=now_pulse2;
            now_pulse2<=key2_pulse;
            light <= song_light;
            
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

reg [255:0] text_data; 

LittleStar song1(.clk(clk), .rst_n(rst), .key(key), .light(song1_light), .speaker(song1_speaker), .s(song1_s));
HappyBirthday song2(.clk(clk), .rst_n(rst), .key(key), .light(song2_light), .speaker(song2_speaker), .s(song2_s));
Spring song3(.clk(clk), .rst_n(rst), .key(key), .light(song3_light), .speaker(song3_speaker), .s(song3_s));

always @* begin
    case(cnt)
        4'b0001: begin
            song_light = song1_light;
            speaker = song1_speaker;
            s = song1_s;
            text_data = "Song1: The Little Star";
        end
        4'b0010: begin
            song_light = song2_light;
            speaker = song2_speaker;
            s = song2_s;
            text_data = "Song2: Happy Birthday";
        end
        4'b0011: begin
            song_light = song3_light;
            speaker = song3_speaker;
            s = song3_s;
            text_data = "Song3: The spring is comming";
        end
        default: begin
            song_light = 7'b0000000;
            speaker = 1'b0;
            s = 1'b0;
            text_data = "Please choose a song";
        end
    endcase
end


 VGAcontroller vga_controller (
   .clk(clk),
   .rst(rst),
   .vga_hsync(vga_hsync),
   .vga_vsync(vga_vsync),
   .vga_red(vga_red),
  
   .vga_green(vga_green),
   .vga_blue(vga_blue),
   .vga_blank(vga_blank),
   .vga_sync(vga_sync),
   .vga_blank_n(vga_blank_n)
 );

endmodule
