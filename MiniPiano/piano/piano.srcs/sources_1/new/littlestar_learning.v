`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 14:12:48
// Design Name: 
// Module Name: little_star
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


module littlestar_learning(
input clk,rst,
input [6:0]note,
input key1,//to switch users
input key2,//to switch users
input key_confirm,//to confirm the level
output speaker,
output s,
output reg [6:0]light,
output [7:0] seg_out,
output [7:0] seg_out2,
output [3:0] segs,
output seg_en2
    );
reg [3:0]users[3:0];
assign s=1'b0;
reg [31:0] notes [7:0];
always @*
begin
    notes [1]=381680;
    notes [2]=340136;
    notes [3]=303030;
    notes [4]=285714;
    notes [5]=255102;
    notes [6]=227273;
    notes [7]=202429;  
end
reg [31:0] allnote[42:0][1:0];
parameter crotchet = 50000000;
parameter minim=100000000;
always @* 
begin
    allnote[1][0]=1;
    allnote[1][1]=crotchet;
    allnote[2][0]=1;
    allnote[2][1]=crotchet;
    allnote[3][0]=5;
    allnote[3][1]=crotchet;
    allnote[4][0]=5;
    allnote[4][1]=crotchet;
    allnote[5][0]=6;
    allnote[5][1]=crotchet;
    allnote[6][0]=6;
    allnote[6][1]=crotchet;
    allnote[7][0]=5;
    allnote[7][1]=minim;
    allnote[8][0]=4;
    allnote[8][1]=crotchet;
    allnote[9][0]=4;
    allnote[9][1]=crotchet;
    allnote[10][0]=3;
    allnote[10][1]=crotchet;
    allnote[11][0]=3;
    allnote[11][1]=crotchet;
    allnote[12][0]=2;
    allnote[12][1]=crotchet;
    allnote[13][0]=2;
    allnote[13][1]=crotchet;
    allnote[14][0]=1;
    allnote[14][1]=minim;
    allnote[15][0]=5;
    allnote[15][1]=crotchet;
    allnote[16][0]=5;
    allnote[16][1]=crotchet;
    allnote[17][0]=4;
    allnote[17][1]=crotchet;
    allnote[18][0]=4;
    allnote[18][1]=crotchet;
    allnote[19][0]=3;
    allnote[19][1]=crotchet;
    allnote[20][0]=3;
    allnote[20][1]=crotchet;
    allnote[21][0]=2;
    allnote[21][1]=minim;
    allnote[22][0]=5;
    allnote[22][1]=crotchet;
    allnote[23][0]=5;
    allnote[23][1]=crotchet;
    allnote[24][0]=4;
    allnote[24][1]=crotchet;
    allnote[25][0]=4;
    allnote[25][1]=crotchet;
    allnote[26][0]=3;
    allnote[26][1]=crotchet;
    allnote[27][0]=3;
    allnote[27][1]=crotchet;
    allnote[28][0]=2;
    allnote[28][1]=minim;
    allnote[29][0]=1;
    allnote[29][1]=crotchet;
    allnote[30][0]=1;
    allnote[30][1]=crotchet;
    allnote[31][0]=5;
    allnote[31][1]=crotchet;
    allnote[32][0]=5;
    allnote[32][1]=crotchet;
    allnote[33][0]=6;
    allnote[33][1]=crotchet;
    allnote[34][0]=6;
    allnote[34][1]=crotchet;
    allnote[35][0]=5;
    allnote[35][1]=minim;
    allnote[36][0]=4;
    allnote[36][1]=crotchet;
    allnote[37][0]=4;
    allnote[37][1]=crotchet;
    allnote[38][0]=3;
    allnote[38][1]=crotchet;
    allnote[39][0]=3;
    allnote[39][1]=crotchet;
    allnote[40][0]=2;
    allnote[40][1]=crotchet;
    allnote[41][0]=2;
    allnote[41][1]=crotchet;
    allnote[42][0]=1;
    allnote[42][1]=minim;
end
wire clk_20ms;
wire key1_pulse;
wire key2_pulse;
wire key3_pulse;
divclk_20ms div(clk,rst,clk_20ms);
debounce_button b1(clk_20ms,rst,key1,key1_pulse);
debounce_button b2(clk_20ms,rst,key2,key2_pulse);
debounce_button b3(clk_20ms,rst,key_confirm,key3_pulse);

reg pre_pulse1;
reg now_pulse1;
reg pre_pulse2;
reg now_pulse2;
reg pre_pulse3;
reg now_pulse3;

reg [31:0] counter ;
reg [31:0] counter_beat ;
reg [31:0] counter_break ;
reg [31:0] counter_deduct ;//every 25000000 ns grade-1
reg pwm ;
reg [5:0] state ;
reg [6:0]grade;
reg [3:0]level;
reg [3:0]user_index;
always @ ( posedge clk ) begin
if(~rst)
 begin
    counter<=0;
    pwm<=0; 
    counter_beat<=0;
    state<=1;
    light<=0;
    counter_break<=0;
    grade<=7'd100;
    counter_deduct<=0;
    //initialize users
    users[1]<=4'b0000;
    users[2]<=4'b0001;
    users[3]<=4'b0010;

    user_index<=4'b0010;

    pre_pulse1<=1'b0;
    now_pulse1<=1'b0;
    pre_pulse2<=1'b0;
    now_pulse2<=1'b0;
    pre_pulse3<=1'b0;
    now_pulse3<=1'b0;

 end
 else
    begin
        pre_pulse1<=now_pulse1;
        now_pulse1<=key1_pulse;
        pre_pulse2<=now_pulse2;
        now_pulse2<=key2_pulse;
        pre_pulse3<=now_pulse3;
        now_pulse3<=key3_pulse;
        if(~pre_pulse1 & now_pulse1)
            begin
            if(user_index==4'b0011) user_index<=user_index;
            else user_index<=user_index+1'b1;
            end 
        else if(~pre_pulse2 & now_pulse2)
            begin
            if(user_index==4'b0000) user_index<=user_index;
            else user_index<=user_index-1'b1;
            end 


        if(state!=43)
        begin//let corresponding light trun on
            case (allnote[state][0])
               1: light = 7'b0000001;
               2: light = 7'b0000010;
               3: light = 7'b0000100;
               4: light = 7'b0001000;
               5: light = 7'b0010000;
               6: light = 7'b0100000;
               7: light = 7'b1000000;
            endcase
       if (note[allnote[state][0]-1]) begin
         if(counter<notes[allnote[state][0]])
            begin
                counter<=counter+1'b1;
                counter_beat<=counter_beat+1'b1;
            end
        else 
            begin
                pwm=~pwm;
                counter<=0;
            end
       end
        if(counter_beat>=allnote[state][1])
        begin
            light<=7'b0000000;
            if (note[allnote[state][0]-1]) 
            begin
                if(counter_deduct<50000000)
                    begin
                        counter_deduct<=counter_deduct+1'b1;
                    end
                else 
                    begin
                        if(grade>0)grade<=grade-1'b1;
                        else grade<=grade;
                        counter_deduct<=0;
                    end
            end
            else
            begin
                counter_break<=counter_break+1;
            end
            if (counter_break==1000000) begin
                counter_beat<=0;
                state<=state+1'b1; 
                counter_break<=0;
            end         
        end   
        end
        else
        begin
            if(~pre_pulse3 & now_pulse3)
            begin
                begin
                    state<=1;
                    grade<=7'd100;
                end
                if (users[user_index]<level) begin
                    users[user_index]<=level;
                end
                else users[user_index]<=users[user_index];
            end
        end
    end
end

always @(*) begin
    if(grade>7'd90)
    begin
        level=4'b0101;
    end
    else if (grade>7'd80&grade<=7'd90) begin
        level=4'b0100;
    end
     else if (grade>7'd70&grade<=7'd80) begin
        level=4'b0011;
    end
     else if (grade>7'd60&grade<=7'd70) begin
        level=4'b0010;
    end
    else
    begin
        level=4'b0001;
    end
end
    
assign speaker=pwm;

scan_seg three_seg(.rst(rst), .clk(clk), .in3(user_index), .in2(4'b1111), .in1(users[user_index]), .in0(4'b1111), .segs(segs), .seg_out(seg_out));
light_7seg_tube seg_tube2(.sw(level), .rst(rst), .seg_out(seg_out2), .seg_en(seg_en2));
endmodule