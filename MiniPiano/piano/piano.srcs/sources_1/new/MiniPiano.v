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
input rst,//reset 
input [6:0] note,
input [3:0] mode,
input up,
input down,
input center,
input adjust,
input right,
output reg [6:0] light,
output reg [3:0] seg_en_left,
output reg [3:0] seg_en_right,
output reg [7:0] seg_out_left,
output reg [7:0] seg_out_right,
output reg speaker,
output wire s,
output wire hsync,
output wire vsync,
output wire [3:0] red,
output wire [3:0] green,
output wire [3:0] blue
);
assign s=1'b0;
reg [3:0] cnt;//reprensent the current mode number
always @* begin
    case(mode)
        4'b1000: cnt=4'b0001;
        4'b0100: cnt=4'b0010;
        4'b0010: cnt=4'b0011;
        4'b0001: cnt=4'b0100;
        default: cnt=4'b0001;
    endcase
end

wire [3:0] top_en_left;
wire [7:0] top_out_left;

wire s_free;
wire speaker_free;
wire [6:0] light_free;
wire free_en_left3;
wire free_en_right0;
wire [7:0] free_out_left;
wire [7:0] free_out_right;

wire s_auto;
wire speaker_auto;
wire [6:0] light_auto;
wire [3:0] auto_en_left;
wire [7:0] auto_out_left;

wire s_learn;
wire speaker_learn;
wire [6:0] light_learn;
wire [3:0] learn_en_left;
wire learn_en_right0;
wire [7:0] learn_out_left;
wire [7:0] learn_out_right;

wire s_record;
wire speaker_record;
wire [6:0] light_record;

scan_seg three_seg(.rst(rst), .clk(clk), .in3(4'b1010), .in2(4'b1011), .in1(cnt), .in0(4'b1111), .segs(top_en_left), .seg_out(top_out_left));
FreeMode free(.clk(clk), .note(note), .key1(up), .key2(down), .key_confirm(center), .rst(mode[3]), .adjust_mode(adjust), .s(s_free), .speaker(speaker_free), .light(light_free), .seg_out(free_out_left), .seg_out2(free_out_right), .seg_en(free_en_left3), .seg_en2(free_en_right0));
AutoPlayMode auto_play(.clk(clk), .key1(up), .key2(down), .rst(mode[2]), .key(center), .segs(auto_en_left), .seg_out(auto_out_left), .light(light_auto), .speaker(speaker_auto), .s(s_auto));
LearnMode learn(.clk(clk), .rst(mode[1]), .note(note), .key1(up), .key2(down), .confirm(center),.speaker(speaker_learn), .s(s_learn), .light(light_learn), .seg_out(learn_out_left), .seg_out2(learn_out_right), .segs(learn_en_left), .seg_en2(learn_en_right0));
MusicRecorder record(.clk(clk), .rst(mode[0]), .play(note), .confirm(center), .replay(up), .light(light_record), .speaker(speaker_record), .s(s_record));
    
wire clk_20ms;
wire key_pulse;
divclk_20ms div(clk,rst,clk_20ms);
debounce_button confirm(clk_20ms,rst,right,key_pulse);
reg pre_pulse;
reg now_pulse;
reg confirm_mode;


always @ (posedge clk) begin
if(~rst)
begin
    pre_pulse<=1'b0;
    now_pulse<=1'b0;
    seg_en_left<=4'b0000;
    seg_en_right<=4'b0000;
    seg_out_left<=8'b00000000;
    seg_out_right<=8'b00000000;
    light<=7'b0000000;
 end
else
    begin
        pre_pulse<=now_pulse;
        now_pulse<=key_pulse;
        confirm_mode<=1'b0;
        if(~pre_pulse&now_pulse)
            begin
              confirm_mode<=~confirm_mode;
            end 
        else         
            begin
                confirm_mode<=confirm_mode;
            end
      end 
      if(confirm_mode) begin
                      case(mode)
                      4'b1000: begin
                          // s<=s_free;
                          speaker<=speaker_free;
                          light<=light_free;
                          seg_en_left <= {free_en_left3,1'b0,1'b0,1'b0};
                          seg_out_left <= free_out_left;
                          seg_en_right <= {1'b0,1'b0,1'b0,free_en_right0};
                          seg_out_right <= free_out_right;
                      end
                      4'b0100:  begin
                          // s<=s_auto;
                          speaker<=speaker_auto;
                          light<=light_auto; 
                          seg_en_left<=auto_en_left;
                          seg_out_left<=auto_out_left;          
                      end
                      4'b0010: begin
                          // s<=s_learn;
                          speaker<=speaker_learn;
                          light<=light_learn;
                          seg_en_left <= learn_en_left;
                          seg_out_left <= learn_out_left;
                          seg_en_right <= {1'b0,1'b0,1'b0,learn_en_right0};
                          seg_out_right <= learn_out_right;           
                      end
                      4'b0001:  begin
                           // s<=s_record;
                           seg_en_left <= 4'b0000;
                           seg_en_right <=4'b0000;
                           speaker<=speaker_record;
                           light<=light_record;          
                      end
                      endcase
                 end
                 else begin
                      seg_en_left <= top_en_left;
                      seg_out_left <= top_out_left;
                      light<=7'b0000000;
                      seg_en_right <= 4'b0000;
                      seg_out_right <= 8'b00000000;
                 end
   
end            

wire vga_clk;
    dcm_25m dcm_25m(
    .clk_in1(clk),
    .resetn(rst),
    .clk_out1(vga_clk)
    );
wire [3:0]yidong;
assign yidong={note[6],note[5],note[4],note[3]};
    VGAcontroller vga(
    .clock(vga_clk),
    .rst(rst),
    .red(red),
    .green(green),
    .blue(blue),
    .hsync(hsync),
    .vsync(vsync),
    .yidong(yidong));
  
    
endmodule
