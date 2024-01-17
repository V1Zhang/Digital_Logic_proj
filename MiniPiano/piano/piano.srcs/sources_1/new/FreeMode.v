`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 11:29:32
// Design Name: 
// Module Name: buzzer
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


module FreeMode (
input wire clk , // Clock signal
input wire [6:0] note, 
input key1,//to raise the tone
input key2,//to lower thr tone
input rst,//reset 
output wire s,
output wire speaker, // Buzzer output signal--sound
output wire [6:0] light,
output [7:0] seg_out,
output [7:0] seg_out2,
output seg_en,
output seg_en2
) ;
reg [3:0] cnt;//reprensent the current tone
//the function of key to change the ptone
wire clk_20ms;
wire key1_pulse;
wire key2_pulse;
assign s = 0;
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
            begin cnt<=4'b0100;
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
           
            if(~pre_pulse2 & now_pulse2)
            begin
            if(cnt>4'b0011) cnt<=cnt-4'b1;
            else cnt<=cnt;
            end 
            
            else if(~pre_pulse1 & now_pulse1)
            begin
             if(cnt<4'b0101) cnt<=cnt+4'b1;
             else cnt<=cnt;
            end 

             else
             cnt<=cnt;
        end  
    end
//
reg [31:0] notes [7:0];
reg [31:0] counter ;
reg pwm ;
// Frequencies of do , re , mi , fa , so , la , si
// Obtain the ratio of how long the buzzer should be active in one second
always @* 
begin
    if(cnt==4'b0100)
    begin
    notes [1]=381680;
    notes [2]=340136;
    notes [3]=303030;
    notes [4]=285714;
    notes [5]=255102;
    notes [6]=227273;
    notes [7]=202429;
    end
    else if(cnt==4'b0101)
    begin
    notes [1]=191113;
    notes [2]=170262;
    notes [3]=151685;
    notes [4]=143172;
    notes [5]=127551;
    notes [6]=113636;
    notes [7]=101238;
    end
    else if(cnt==4'b0011)
    begin
    notes [1]=764526;
    notes [2]=681059;
    notes [3]=606796;
    notes [4]=572738;
    notes [5]=510209;
    notes [6]=454545;
    notes [7]=405022;
    end
end 
   
reg [3:0] point = 3'b0000;
initial
begin
pwm =0;
end
always @ * begin
    case(note)
        7'b1000000: point = 4'b0001; 
        7'b0100000: point = 4'b0010;
        7'b0010000: point = 4'b0011;
        7'b0001000: point = 4'b0100;
        7'b0000100: point = 4'b0101;
        7'b0000010: point = 4'b0110;
        7'b0000001: point = 4'b0111;
        default:point = 4'b0000;
    endcase
end


   
 
always @ ( posedge clk ) begin
    if(counter<notes[point]||point==1'b0)
    begin
        counter<=counter+1'b1;
    end
    else begin
        pwm=~pwm;
        counter<=0;
    end
end
assign speaker = pwm ; // Output a PWM signal to the buzzer 
assign light = note; // the indicator light of do , re , mi , fa , so , la , si
light_7seg_tube seg_tube(.sw(point), .rst(rst), .seg_out(seg_out), .seg_en(seg_en));
light_7seg_tube seg_tube2(.sw(cnt), .rst(rst), .seg_out(seg_out2), .seg_en(seg_en2));
endmodule
