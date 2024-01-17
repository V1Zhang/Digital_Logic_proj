`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 15:10:17
// Design Name: 
// Module Name: happy_birthday
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


module HappyBirthday(
input clk,rst_n,key,
input reset1,
input reset2,
output reg [6:0]light,
output speaker,
output s
    );
assign s=1'b0;
reg [31:0] notes [7:0];
always @*
begin
    notes [5]=510209;//c3 5
    notes [6]=454545;//c3 6
    notes [7]=405022;//c3 7
    notes [1]=381680;//c4 1
    notes [2]=340136;//c4 2
    notes [3]=303030;//c4 3
    notes [4]=285714;//c4 4
    notes [0]=255102;//c4 5
end
reg [31:0] allnote[42:0][1:0];
parameter quaver=50000000;
parameter crotchet=100000000;
parameter minim=200000000;


always @* 
begin
    allnote[1][0]=5;
    allnote[1][1]=quaver;
    allnote[2][0]=5;
    allnote[2][1]=quaver;
    allnote[3][0]=6;
    allnote[3][1]=crotchet;
    allnote[4][0]=5;
    allnote[4][1]=crotchet;
    allnote[5][0]=1;
    allnote[5][1]=crotchet;
    allnote[6][0]=7;
    allnote[6][1]=minim;
    allnote[7][0]=5;
    allnote[7][1]=quaver;
    allnote[8][0]=5;
    allnote[8][1]=quaver;
    allnote[9][0]=6;
    allnote[9][1]=crotchet;
    allnote[10][0]=5;
    allnote[10][1]=crotchet;
    allnote[11][0]=2;
    allnote[11][1]=crotchet;
    allnote[12][0]=1;
    allnote[12][1]=minim;
    allnote[13][0]=5;
    allnote[13][1]=quaver;
    allnote[14][0]=5;
    allnote[14][1]=quaver;
    allnote[15][0]=0;
    allnote[15][1]=crotchet;
    allnote[16][0]=3;
    allnote[16][1]=crotchet;
    allnote[17][0]=1;
    allnote[17][1]=crotchet;
    allnote[18][0]=7;
    allnote[18][1]=crotchet;
    allnote[19][0]=6;
    allnote[19][1]=crotchet;
    allnote[20][0]=4;
    allnote[20][1]=quaver;
    allnote[21][0]=4;
    allnote[21][1]=quaver;
    allnote[22][0]=3;
    allnote[22][1]=crotchet;
    allnote[23][0]=1;
    allnote[23][1]=crotchet;
    allnote[24][0]=2;
    allnote[24][1]=crotchet;
    allnote[25][0]=1;
    allnote[25][1]=minim;
end
wire clk_20ms;
wire key_pulse;
divclk_20ms div(clk,rst_n,clk_20ms);
debounce_button b(clk_20ms,rst_n,key,key_pulse);
//reset
wire key1pulse;
wire key2pulse;
debounce_button b1(clk_20ms,rst_n,reset1,key1pulse);
debounce_button b2(clk_20ms,rst_n,reset2,key2pulse);
reg prepulse1;
reg nowpulse1;
reg prepulse2;
reg nowpulse2;
//
reg [31:0] counter ;
reg [31:0] counter_beat ;
reg [31:0] counter_stop ;
reg pwm ;
reg [5:0] state ;
reg stop;
reg pre_pulse1;
reg now_pulse1;
always @ ( posedge clk ) begin
if(~rst_n)
 begin
    counter<=0;
    pwm<=0; 
    counter_beat<=0;
    state<=0;
    counter_stop<=0;
    pre_pulse1<=1'b0;
    now_pulse1<=1'b0;
    prepulse1<=1'b0;
    nowpulse1<=1'b0;
    prepulse2<=1'b0;
    nowpulse2<=1'b0;
    stop<=1'b1;
 end
 else
    begin
        prepulse1<=nowpulse1;
        nowpulse1<=key1pulse;
        prepulse2<=nowpulse2;
        pre_pulse1<=now_pulse1;
        now_pulse1<=key_pulse;
       if(~prepulse1 & nowpulse1)
           begin
           state<=0;
           stop<=1;
           end   
        else if(~prepulse2 & nowpulse2)
           begin
           state<=0;
           stop<=1;
           end 
        else if(~pre_pulse1&now_pulse1)
            begin
              stop=~stop;
            end 
        else 
            begin
                stop=stop;
                state<=state;
            end

        if(state!=26)
         // light
               begin
                   case(allnote[state][0])
                       1: light = 7'b1000000;
                       2: light = 7'b0100000;
                       3: light = 7'b0010000;
                       4: light = 7'b0001000;
                       5: light = 7'b0000100;
                       6: light = 7'b0000010;
                       7: light = 7'b0000001;
                       default: light = 7'b0000000;
                   endcase
            if(counter_beat<allnote[state][1])
            begin
                if(stop)
                begin
                    pwm<=0;
                    counter_beat<=counter_beat;
                    counter<=counter;
                end
                else
                begin
                    counter_beat<=counter_beat+1'b1;
                        if(counter<notes[allnote[state][0]])
                            begin
                                counter<=counter+1'b1;
                            end
                        else 
                            begin
                                pwm=~pwm;
                                counter<=0;
                            end
                end  
            end
            else
            begin
                pwm<=0;
            if(counter_stop<1000000)
                begin
                    counter_stop<=counter_stop+1'b1;
                end
                else 
                begin
                counter_beat<=0;
                state<=state+1'b1;
                counter_stop<=0;
                end 
            end      
            end
        else
        begin
            state<=0;
            stop<=1'b1;
        end
    end
end
assign speaker=pwm;
endmodule
