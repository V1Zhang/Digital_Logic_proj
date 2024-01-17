`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 20:46:45
// Design Name: 
// Module Name: Spring
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


module Spring(
input clk,rst_n,key,
output reg [6:0]light,
output speaker,
output s
    );
assign s=1'b0;
reg [31:0] notes [16:0];
always @*
begin
    notes [0]=340524;
    notes [1]=270277;
    notes [2]=255105;
    notes [3]=227272;
    notes [4]=202478;
    notes [5]=180386;
    notes [6]=170262;
    notes [7]=151686;
    notes [8]=135137;
    notes [9]=113636;
    notes [10]=101238;
    notes [11]=90193;
    notes [12]=85131;
    notes [13]=75843;
    notes [14]=67568;
    notes [15]=56818;
    notes [16]=50619;
end
reg [31:0] allnote[288:0][1:0];
parameter semiquaver=25000000;
parameter quaver=50000000;
parameter crotchet=100000000;
parameter minim=200000000;


always @* 
begin
    allnote[1][0]=4;
    allnote[1][1]=semiquaver;
    allnote[2][0]=5;
    allnote[2][1]=semiquaver;
    allnote[3][0]=6;
    allnote[3][1]=semiquaver;
    allnote[4][0]=7;
    allnote[4][1]=quaver;
    allnote[5][0]=10;
    allnote[5][1]=semiquaver;
    allnote[6][0]=9;
    allnote[6][1]=quaver;
    allnote[7][0]=10;
    allnote[7][1]=quaver;
    allnote[8][0]=6;
    allnote[8][1]=semiquaver;
    allnote[9][0]=7;
    allnote[9][1]=quaver;
    allnote[10][0]=10;
    allnote[10][1]=semiquaver;
    allnote[11][0]=9;
    allnote[11][1]=quaver;
    allnote[12][0]=10;
    allnote[12][1]=quaver;
    allnote[13][0]=7;
    allnote[13][1]=semiquaver;
    allnote[14][0]=8;
    allnote[14][1]=quaver;
    allnote[15][0]=10;
    allnote[15][1]=semiquaver;
    allnote[16][0]=9;
    allnote[16][1]=quaver;
    allnote[17][0]=10;
    allnote[17][1]=quaver;
    allnote[18][0]=8;
    allnote[18][1]=semiquaver;
    allnote[19][0]=6;
    allnote[19][1]=semiquaver;
    allnote[20][0]=7;
    allnote[20][1]=semiquaver;
    allnote[21][0]=8;
    allnote[21][1]=semiquaver;
    allnote[22][0]=9;
    allnote[22][1]=quaver;
    allnote[23][0]=8;
    allnote[23][1]=quaver;
    allnote[24][0]=6;
    allnote[24][1]=semiquaver;
    allnote[25][0]=7;
    allnote[25][1]=quaver;
    //
    allnote [26][0]=10;
    allnote [26][1]=semiquaver;
    allnote [27][0]=9;
    allnote [27][1]=quaver;
    allnote [28][0]=10;
    allnote [28][1]=semiquaver;
    allnote [29][0]=6;
    allnote [29][1]=semiquaver;
    allnote [30][0]=7;
    allnote [30][1]=quaver;
    allnote [31][0]=10;
    allnote [31][1]=semiquaver;
    allnote [32][0]=9;
    allnote [32][1]=quaver;
    allnote [33][0]=10;
    allnote [33][1]=quaver;
    allnote [34][0]=7;
    allnote [34][1]=semiquaver;
    allnote [35][0]=8;
    allnote [35][1]=quaver;
    allnote [36][0]=10;
    allnote [36][1]=semiquaver;
    allnote [37][0]=9;
    allnote [37][1]=quaver;
    allnote [38][0]=10;
    allnote [38][1]=quaver;
    allnote [39][0]=8;
    allnote [39][1]=semiquaver;
    allnote [40][0]=12;
    allnote [40][1]=semiquaver;
    allnote [41][0]=8;
    allnote [41][1]=semiquaver;
    allnote [42][0]=7;
    allnote [42][1]=semiquaver;
    allnote [43][0]=11;
    allnote [43][1]=quaver;
    allnote [44][0]=6;
    allnote [44][1]=semiquaver;
    allnote [45][0]=10;
    allnote [45][1]=semiquaver;
    allnote [46][0]=8;
    allnote [46][1]=semiquaver;
    allnote [47][0]=13;
    allnote [47][1]=quaver;
    allnote [48][0]=16;
    allnote [48][1]=semiquaver;
    allnote [49][0]=15;
    allnote [49][1]=quaver;
    allnote [50][0]=16;
    allnote [50][1]=quaver;
    allnote [51][0]=13;
    allnote [51][1]=semiquaver;
    allnote [52][0]=14;
    allnote [52][1]=quaver;
    allnote [53][0]=16;
    allnote [53][1]=semiquaver;
    allnote [54][0]=15;
    allnote [54][1]=quaver;
    allnote [55][0]=16;
    allnote [55][1]=quaver;
    allnote [56][0]=14;
    allnote [56][1]=semiquaver;
    allnote [57][0]=12;
    allnote [57][1]=semiquaver;
    allnote [58][0]=13;
    allnote [58][1]=semiquaver;
    allnote [59][0]=14;
    allnote [59][1]=semiquaver;
    allnote [60][0]=15;
    allnote [60][1]=75000000;
    allnote [61][0]=14;
    allnote [61][1]=semiquaver;
    allnote [62][0]=12;
    allnote [62][1]=semiquaver;
    allnote [63][0]=6;
    allnote [63][1]=crotchet;
    allnote [64][0]=7;
    allnote [64][1]=quaver;
    allnote [65][0]=8;
    allnote [65][1]=quaver;
    allnote [66][0]=7;
    allnote [66][1]=quaver;
    allnote [67][0]=6;
    allnote [67][1]=quaver;
    allnote [68][0]=4;
    allnote [68][1]=quaver;
    allnote [69][0]=3;
    allnote [69][1]=quaver;
    allnote [70][0]=4;
    allnote [70][1]=400000000;
    allnote [71][0]=4;
    allnote [71][1]=crotchet;
    allnote [72][0]=8;
    allnote [72][1]=crotchet;
    allnote [73][0]=7;
    allnote [73][1]=75000000;
    allnote [74][0]=7;
    allnote [74][1]=semiquaver;
    allnote [75][0]=8;
    allnote [75][1]=semiquaver;
    allnote [76][0]=7;
    allnote [76][1]=semiquaver;
    allnote [77][0]=6;
    allnote [77][1]=semiquaver;
    allnote [78][0]=5;
    allnote [78][1]=semiquaver;
    //
        allnote [79][0]=4;
    allnote [79][1]=crotchet;
    allnote [80][0]=3;
    allnote [80][1]=quaver;
    allnote [81][0]=4;
    allnote [81][1]=semiquaver;
    allnote [82][0]=3;
    allnote [82][1]=semiquaver;
    allnote [83][0]=1;
    allnote [83][1]=minim;
    allnote [84][0]=2;
    allnote [84][1]=crotchet;
    allnote [85][0]=6;
    allnote [85][1]=crotchet;
    allnote [86][0]=5;
    allnote [86][1]=75000000;
    allnote [87][0]=5;
    allnote [87][1]=semiquaver;
    allnote [88][0]=6;
    allnote [88][1]=semiquaver;
    allnote [89][0]=5;
    allnote [89][1]=semiquaver;
    allnote [90][0]=4;
    allnote [90][1]=semiquaver;
    allnote [91][0]=3;
    allnote [91][1]=semiquaver;
    allnote [92][0]=6;
    allnote [92][1]=crotchet;
    allnote [93][0]=7;
    allnote [93][1]=quaver;
    allnote [94][0]=6;
    allnote [94][1]=semiquaver;
    allnote [95][0]=7;
    allnote [95][1]=semiquaver;
    allnote [96][0]=8;
    allnote [96][1]=minim;
    allnote [97][0]=4;
    allnote [97][1]=crotchet;
    allnote [98][0]=8;
    allnote [98][1]=crotchet;
    allnote [99][0]=7;
    allnote [99][1]=75000000;
    allnote [100][0]=7;
    allnote [100][1]=semiquaver;
    allnote [101][0]=8;
    allnote [101][1]=semiquaver;
    allnote [102][0]=7;
    allnote [102][1]=semiquaver;
    allnote [103][0]=6;
    allnote [103][1]=semiquaver;
    allnote [104][0]=5;
    allnote [104][1]=semiquaver;
    allnote [105][0]=4;
    allnote [105][1]=crotchet;
    allnote [106][0]=3;
    allnote [106][1]=quaver;
    allnote [107][0]=4;
    allnote [107][1]=semiquaver;
    allnote [108][0]=3;
    allnote [108][1]=semiquaver;
    allnote [109][0]=1;
    allnote [109][1]=crotchet;
    allnote [110][0]=6;
    allnote [110][1]=quaver;
    allnote [111][0]=5;
    allnote [111][1]=semiquaver;
    allnote [112][0]=6;
    allnote [112][1]=125000000;
    allnote [113][0]=5;
    allnote [113][1]=quaver;
    allnote [114][0]=4;
    allnote [114][1]=semiquaver;
    allnote [115][0]=5;
    allnote [115][1]=125000000;
    allnote [116][0]=4;
    allnote [116][1]=quaver;
    allnote [117][0]=3;
    allnote [117][1]=semiquaver;
    allnote [118][0]=4;
    allnote [118][1]=125000000;
    allnote [119][0]=3;
    allnote [119][1]=quaver;
    allnote [120][0]=5;
    allnote [120][1]=semiquaver;
    allnote [121][0]=4;
    allnote [121][1]=125000000;
    allnote [122][0]=6;
    allnote [122][1]=quaver;
    allnote [123][0]=5;
    allnote [123][1]=semiquaver;
    allnote [124][0]=6;
    allnote [124][1]=125000000;
    allnote [125][0]=6;
    allnote [125][1]=quaver;
    allnote [126][0]=5;
    allnote [126][1]=semiquaver;
    allnote [127][0]=6;
    allnote [127][1]=125000000;
    allnote [128][0]=7;
    allnote [128][1]=quaver;
    allnote [129][0]=6;
    allnote [129][1]=semiquaver;
    allnote [130][0]=5;
    allnote [130][1]=125000000;
    allnote [131][0]=3;
    allnote [131][1]=quaver;
    allnote [132][0]=4;
    allnote [132][1]=semiquaver;
    allnote [133][0]=5;
    allnote [133][1]=125000000;
    allnote [134][0]=6;
    allnote [134][1]=quaver;
    allnote [135][0]=5;
    allnote [135][1]=semiquaver;
    allnote [136][0]=6;
    allnote [136][1]=125000000;
    allnote [137][0]=6;
    allnote [137][1]=quaver;
    allnote [138][0]=5;
    allnote [138][1]=semiquaver;
    allnote [139][0]=6;
    allnote [139][1]=125000000;
    allnote [140][0]=7;
    allnote [140][1]=quaver;
    allnote [141][0]=6;
    allnote [141][1]=semiquaver;
    allnote [142][0]=5;
    allnote [142][1]=125000000;
    allnote [143][0]=6;
    allnote [143][1]=quaver;
    allnote [144][0]=7;
    allnote [144][1]=semiquaver;
    allnote [145][0]=8;
    allnote [145][1]=125000000;
    allnote [146][0]=9;
    allnote [146][1]=quaver;
    allnote [147][0]=8;
    allnote [147][1]=quaver;
    allnote [148][0]=7;
    allnote [148][1]=quaver;
    allnote [149][0]=10;
    allnote [149][1]=semiquaver;
    allnote [150][0]=9;
    allnote [150][1]=75000000;
    allnote [151][0]=10;
    allnote [151][1]=quaver;
    allnote [152][0]=6;
    allnote [152][1]=semiquaver;
    allnote [153][0]=7;
    allnote [153][1]=quaver;
    allnote [154][0]=6;
    allnote [154][1]=quaver;
    allnote [155][0]=7;
    allnote [155][1]=quaver;
    allnote [156][0]=8;
    allnote [156][1]=quaver;
    allnote [157][0]=7;
    allnote [157][1]=quaver;
    allnote [158][0]=6;
    allnote [158][1]=semiquaver;
    allnote [159][0]=4;
    allnote [159][1]=quaver;
    allnote [160][0]=10;
    allnote [160][1]=quaver;
    allnote [161][0]=8;
    allnote [161][1]=semiquaver;
    allnote [162][0]=6;
    allnote [162][1]=semiquaver;
    allnote [163][0]=7;
    allnote [163][1]=semiquaver;
    allnote [164][0]=8;
    allnote [164][1]=semiquaver;
    allnote [165][0]=9;
    allnote [165][1]=semiquaver;
    allnote [166][0]=9;
    allnote [166][1]=quaver;
    allnote [167][0]=8;
    allnote [167][1]=semiquaver;
    allnote [168][0]=7;
    allnote [168][1]=75000000;
    allnote [169][0]=7;
    allnote [169][1]=quaver;
    allnote [170][0]=7;
    allnote [170][1]=quaver;
    allnote [171][0]=6;
    allnote [171][1]=semiquaver;
    allnote [172][0]=7;
    allnote [172][1]=75000000;
    allnote [173][0]=8;
    allnote [173][1]=quaver;
    allnote [174][0]=6;
    allnote [174][1]=quaver;
    allnote [175][0]=7;
    allnote [175][1]=semiquaver;
    allnote [176][0]=8;
    allnote [176][1]=125000000;
    allnote [177][0]=0;
    allnote [177][1]=semiquaver;
    allnote [178][0]=1;
    allnote [178][1]=semiquaver;
    allnote [179][0]=4;
    allnote [179][1]=semiquaver;
    allnote [180][0]=5;
    allnote [180][1]=semiquaver;
    allnote [181][0]=6;
    allnote [181][1]=crotchet;
    allnote [182][0]=9;
    allnote [182][1]=quaver;
    allnote [183][0]=8;
    allnote [183][1]=quaver;
    allnote [184][0]=7;
    allnote [184][1]=quaver;
    allnote [185][0]=10;
    allnote [185][1]=semiquaver;
    allnote [186][0]=9;
    allnote [186][1]=quaver;
    allnote [187][0]=10;
    allnote [187][1]=quaver;
    allnote [188][0]=6;
    allnote [188][1]=semiquaver;
    allnote [189][0]=7;
    allnote [189][1]=quaver;
    allnote [190][0]=6;
    allnote [190][1]=quaver;
    allnote [191][0]=7;
    allnote [191][1]=quaver;
    allnote [192][0]=8;
    allnote [192][1]=quaver;
    allnote [193][0]=7;
    allnote [193][1]=quaver;
    allnote [194][0]=6;
    allnote [194][1]=semiquaver;
    allnote [195][0]=4;
    allnote [195][1]=quaver;
    allnote [196][0]=10;
    allnote [196][1]=quaver;
    allnote [197][0]=8;
    allnote [197][1]=semiquaver;
    allnote [198][0]=6;
    allnote [198][1]=semiquaver;
    allnote [199][0]=7;
    allnote [199][1]=semiquaver;
    allnote [200][0]=8;
    allnote [200][1]=semiquaver;
    allnote [201][0]=9;
    allnote [201][1]=75000000;
    allnote [202][0]=8;
    allnote [202][1]=semiquaver;
    allnote [203][0]=6;
    allnote [203][1]=semiquaver;
    allnote [204][0]=6;
    allnote [204][1]=crotchet;
    allnote [205][0]=7;
    allnote [205][1]=quaver;
    allnote [206][0]=8;
    allnote [206][1]=quaver;
    allnote [207][0]=7;
    allnote [207][1]=quaver;
    allnote [208][0]=6;
    allnote [208][1]=quaver;
    allnote [209][0]=4;
    allnote [209][1]=quaver;
    allnote [210][0]=3;
    allnote [210][1]=quaver;
    allnote [211][0]=4;
    allnote [211][1]=crotchet;
    allnote [212][0]=0;
    allnote [212][1]=semiquaver;
    allnote [213][0]=1;
    allnote [213][1]=semiquaver;
    allnote [214][0]=4;
    allnote [214][1]=semiquaver;
    allnote [215][0]=5;
    allnote [215][1]=semiquaver;
    allnote [216][0]=6;
    allnote [216][1]=crotchet;
    allnote [217][0]=15;
    allnote [217][1]=quaver;
    allnote [218][0]=14;
    allnote [218][1]=quaver;
    allnote [219][0]=7;
    allnote [219][1]=quaver;
    allnote [220][0]=10;
    allnote [220][1]=semiquaver;
    allnote [221][0]=9;
    allnote [221][1]=quaver;
    allnote [222][0]=10;
    allnote [222][1]=quaver;
    allnote [223][0]=6;
    allnote [223][1]=semiquaver;
    allnote [224][0]=7;
    allnote [224][1]=quaver;
    allnote [225][0]=12;
    allnote [225][1]=quaver;
    allnote [226][0]=13;
    allnote [226][1]=quaver;
    allnote [227][0]=14;
    allnote [227][1]=quaver;
    allnote [228][0]=13;
    allnote [228][1]=quaver;
    allnote [229][0]=6;
    allnote [229][1]=semiquaver;
    allnote [230][0]=4;
    allnote [230][1]=quaver;
    allnote [231][0]=10;
    allnote [231][1]=quaver;
    allnote [232][0]=8;
    allnote [232][1]=semiquaver;
    allnote [233][0]=6;
    allnote [233][1]=semiquaver;
    allnote [234][0]=7;
    allnote [234][1]=semiquaver;
    allnote [235][0]=8;
    allnote [235][1]=semiquaver;
    allnote [236][0]=9;
    allnote [236][1]=semiquaver;
    allnote [237][0]=15;
    allnote [237][1]=quaver;
    allnote [238][0]=14;
    allnote [238][1]=semiquaver;
    allnote [239][0]=13;
    allnote [239][1]=75000000;
    allnote [240][0]=13;
    allnote [240][1]=quaver;
    allnote [241][0]=13;
    allnote [241][1]=quaver;
    allnote [242][0]=12;
    allnote [242][1]=semiquaver;
    allnote [243][0]=13;
    allnote [243][1]=semiquaver;
    allnote [244][0]=13;
    allnote [244][1]=quaver;
    allnote [245][0]=14;
    allnote [245][1]=quaver;
    allnote [246][0]=12;
    allnote [246][1]=quaver;
    allnote [247][0]=13;
    allnote [247][1]=semiquaver;
    allnote [248][0]=14;
    allnote [248][1]=125000000;
    allnote [249][0]=0;
    allnote [249][1]=semiquaver;
    allnote [250][0]=1;
    allnote [250][1]=semiquaver;
    allnote [251][0]=4;
    allnote [251][1]=semiquaver;
    allnote [252][0]=5;
    allnote [252][1]=semiquaver;
    allnote [253][0]=6;
    allnote [253][1]=quaver;
    allnote [254][0]=15;
    allnote [254][1]=quaver;
    allnote [255][0]=14;
    allnote [255][1]=quaver;
    allnote [256][0]=13;
    allnote [256][1]=quaver;
    allnote [257][0]=10;
    allnote [257][1]=semiquaver;
    allnote [258][0]=9;
    allnote [258][1]=quaver;
    allnote [259][0]=10;
    allnote [259][1]=quaver;
    allnote [260][0]=6;
    allnote [260][1]=semiquaver;
    allnote [261][0]=7;
    allnote [261][1]=quaver;
    allnote [262][0]=12;
    allnote [262][1]=quaver;
    allnote [263][0]=13;
    allnote [263][1]=quaver;
    allnote [264][0]=14;
    allnote [264][1]=quaver;
    allnote [265][0]=13;
    allnote [265][1]=quaver;
    allnote [266][0]=6;
    allnote [266][1]=semiquaver;
    allnote [267][0]=4;
    allnote [267][1]=quaver;
    allnote [268][0]=10;
    allnote [268][1]=quaver;
    allnote [269][0]=8;
    allnote [269][1]=semiquaver;
    allnote [270][0]=6;
    allnote [270][1]=semiquaver;
    allnote [271][0]=7;
    allnote [271][1]=semiquaver;
    allnote [272][0]=8;
    allnote [272][1]=semiquaver;
    allnote [273][0]=7;
    allnote [273][1]=75000000;
    allnote [274][0]=8;
    allnote [274][1]=semiquaver;
    allnote [275][0]=6;
    allnote [275][1]=semiquaver;
    allnote [276][0]=6;
    allnote [276][1]=crotchet;
    allnote [277][0]=7;
    allnote [277][1]=quaver;
    allnote [278][0]=8;
    allnote [278][1]=quaver;
    allnote [279][0]=7;
    allnote [279][1]=quaver;
    allnote [280][0]=6;
    allnote [280][1]=quaver;
    allnote [281][0]=4;
    allnote [281][1]=quaver;
    allnote [282][0]=3;
    allnote [282][1]=quaver;
    allnote [283][0]=4;
    allnote [283][1]=crotchet;
    allnote [284][0]=0;
    allnote [284][1]=semiquaver;
    allnote [285][0]=1;
    allnote [285][1]=semiquaver;
    allnote [286][0]=4;
    allnote [286][1]=semiquaver;
    allnote [287][0]=5;
    allnote [287][1]=semiquaver;
    allnote [288][0]=12;
    allnote [288][1]=minim;

end
wire clk_20ms;
wire key_pulse;
divclk_20ms div(clk,rst_n,clk_20ms);
debounce_button b(clk_20ms,rst_n,key,key_pulse);
reg [31:0] counter ;
reg [31:0] counter_beat ;
reg [31:0] counter_stop ;
reg pwm ;
reg [8:0] state ;
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
    stop<=1'b1;
 end
 else
    begin
        pre_pulse1<=now_pulse1;
        now_pulse1<=key_pulse;
        if(~pre_pulse1&now_pulse1)
            begin
              stop=~stop;
            end 
        else 
            begin
                stop=stop;
            end

        if(state!=289)
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
               end
        begin
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
            counter_beat<=0;
            state<=state+1'b1;
            counter_stop<=0;
        end      
        end
    end
end
assign speaker=pwm;
endmodule
