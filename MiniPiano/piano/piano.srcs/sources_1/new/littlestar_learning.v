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
input clk,rst_n,
input [6:0]note,
output speaker,
output s,
output reg [6:0]light
    );
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
reg [31:0] counter ;
reg [31:0] counter_beat ;
reg [31:0] counter_break ;
reg pwm ;
reg [5:0] state ;

always @ ( posedge clk ) begin
if(~rst_n)
 begin
    counter<=0;
    pwm<=0; 
    counter_beat<=0;
    state<=1;
    light<=0;
    counter_break<=0;
 end
 else
    begin
        if(state!=43)
        begin//let corresponding light trun on
            case (allnote[state][0])
                1:light<=7'b0000001;
                2:light<=7'b0000010;
                3:light<=7'b0000100;
                4:light<=7'b0001000;
                5:light<=7'b0010000;
                6:light<=7'b0100000;
                7:light<=7'b1000000;
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
            if (!note[allnote[state][0]-1]) begin
                counter_break<=counter_break+1;
            end
            if (counter_break==1000000) begin
                counter_beat<=0;
                state<=state+1'b1; 
                counter_break<=0;
            end         
        end   
        end
    end
end
assign speaker=pwm;
endmodule