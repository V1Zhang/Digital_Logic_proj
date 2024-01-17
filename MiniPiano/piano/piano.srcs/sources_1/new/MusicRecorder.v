`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/31 00:50:21
// Design Name: 
// Module Name: MusicRecorder
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


module MusicRecorder (
  input wire clk,
  input wire rst,
  input [6:0] play,
  input wire confirm,
  input wire replay,
  output reg [6:0] light,
  output speaker,
  output s
);

// Constants
parameter MAX_RECORD_LENGTH = 300; 
assign s=1'b0;
reg [31:0] notes [7:0];
always @*
begin
    notes [0]=10000000;  
    notes [1]=381680;
    notes [2]=340136;
    notes [3]=303030;
    notes [4]=285714;
    notes [5]=255102;
    notes [6]=227273;
    notes [7]=202429;  
end


reg [31:0] recorded_data[MAX_RECORD_LENGTH:0][1:0];
reg [8:0] state ;
reg [8:0] max_state;
reg [31:0] counter ;
reg [31:0] counter_beat ;
reg [31:0] counter_stop ;
reg pwm ;

wire clk_20ms;
divclk_20ms div(clk,rst,clk_20ms);
wire confirm_key;
debounce_button c(clk_20ms,rst,confirm,confirm_key);
wire replay_key;
debounce_button r(clk_20ms,rst,replay,replay_key);
reg save;
reg pre_confirm;
reg now_confirm;

reg pre_replay;
reg now_replay;

reg [6:0] pre_play;
reg [6:0] now_play;
reg[3:0]point=4'b0000;
reg start=1'b0;
always @ * begin
    case(play)
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
always @ ( posedge clk ) 
begin
if(~rst)
    begin
        light<=0;
        pwm<=1'b0;
        counter<=0;
        counter_beat<=0;
        state<=0;
        max_state<=0;
        counter_stop<=0;
        pre_confirm<=1'b0;
        now_confirm<=1'b0;
        pre_replay<=1'b0;
        now_replay<=1'b0;
        save<=1'b0;
        pre_play<=7'b0000000;
        now_play<=7'b0000000;
        state<=1'b0;
    end
else
    begin
        pre_confirm<=now_confirm;
        now_confirm<=confirm_key;
        pre_replay<=now_replay;
        now_replay<=replay_key;
            if(~pre_confirm & now_confirm)
                begin
                max_state <= state;
                save<=~save;
                end 
            else 
                begin 
                save<=save;
                end
            if(~save) 
                begin
                    pre_play <= now_play;
                    now_play<=play;
                    if(state!=MAX_RECORD_LENGTH)
                    begin
                        case(play)
                            7'b1000000: begin
                                    recorded_data[state][0]<=1;
                                    light <= 7'b1000000;
                            end
                            7'b0100000: begin
                                    recorded_data[state][0]<=2;
                                    light <= 7'b0100000;
                            end
                            7'b0010000: begin
                                    recorded_data[state][0]<=3;
                                    light <= 7'b0010000;
                            end
                            7'b0001000: begin
                                    recorded_data[state][0]<=4;
                                    light <= 7'b0001000;
                            end
                            7'b0000100: begin
                                    recorded_data[state][0]<=5;
                                    light <= 7'b0000100;
                            end
                            7'b0000010: begin
                                    recorded_data[state][0]<=6;
                                    light <= 7'b0000010;
                            end
                            7'b0000001: begin
                                    recorded_data[state][0]<=7;

                                    light <= 7'b0000001;
                            end
                            default: begin
                                    light <= 7'b0000000;
                            end
                        endcase
                        // last time 
                        if(pre_play==now_play)
                            begin
                                counter_beat<=counter_beat+1'b1; 
                                if(point>0&counter<notes[point]) 
                                begin
                                    counter<=counter+1'b1;
                                end
                                else
                                begin
                                    pwm=~pwm;
                                    counter<=0;
                                end 
                            end
                        else 
                            begin
                                pwm<=1'b0;
                                recorded_data[state][1]<=counter_beat;
                                state <= state+1;
                                counter_beat<=0;
                            end
                    end
                end
        else 
        begin
            if(~pre_replay & now_replay)
                begin
                start<=~start;
                end 
            else 
                begin
                    start<=start;
                end
            if(~start)
            begin
                light<=7'b0000000;
                counter<=0;
                counter_beat<=0;
                state<=0;
                counter_stop<=0;
                start = 1'b1;
            end
           else
           begin
              if(state<=max_state)
              begin
                  case(recorded_data[state][0])
                      1: light <= 7'b1000000;
                      2: light <= 7'b0100000;
                      3: light <= 7'b0010000;
                      4: light <= 7'b0001000;
                      5: light <= 7'b0000100;
                      6: light <= 7'b0000010;
                      7: light <= 7'b0000001;
                      default: light <= 7'b0000000;
                  endcase
                    if(counter_beat<recorded_data[state][1])
                    begin
                        counter_beat<=counter_beat+1'b1;
                            if(recorded_data[state][0]>0&counter<notes[recorded_data[state][0]])
                                begin
                                    counter<=counter+1'b1;
                                end
                            else 
                                begin
                                    pwm=~pwm;
                                    counter<=0;
                                end
                    end  
                    else
                    begin
                        pwm<=0;
                        state <= state+1'b1;   
                        counter_beat<=0;
                    end
              end
            end
        end
    end
end
assign speaker=pwm;
endmodule


