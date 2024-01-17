`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/30 23:58:48
// Design Name: 
// Module Name: VGAcontroller
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


module VGAcontroller (
input wire clock, //系统时钟 100MHZ
input wire rst, //时钟复位端
output reg [3:0] red, // VGA 数据输出
output reg [3:0] green,
output reg [3:0] blue,
output reg hsync, // VGA 行同步信号
output reg vsync // VGA 场同步信
);
wire [3:0] yidong;
reg[9:0] hcount = 0; // 行扫描计数器
reg[9:0] vcount = 0; // 场扫描计数器
wire hcount_ov; //行扫描结束标志位
wire vcount_ov; //帧扫描结束标志位
wire data_act; //显示阶段 data 有效
//VGA 行、场扫描时序参数表
parameter hsync_end = 10'd95, //行同步信号（低电平）结束
hdata_begin = 10'd143, //行显示开始
hdata_end = 10'd783, //行显示结束
hpixel_end = 10'd799, //行显示前延结束
vsync_end = 10'd1, vdata_begin = 10'd34, vdata_end = 10'd514, vline_end =10'd524;
//VGA 驱动程序
//行扫描
always@(posedge clock)
begin
if(hcount_ov) //若行扫描标志位为 1，换行
hcount<=10'd0; //行扫描计数器置 0
else
hcount<= hcount +1; //行扫描计数器+1
end
assign hcount_ov = (hcount == hpixel_end); //行计数器=799，扫描一行结束，
//场扫描
always@(posedge clock)
begin
if(hcount_ov) //行扫描标志位有效
begin
if(vcount_ov) //帧扫描标志位有效，场扫描计数器置零，重新计数
vcount<=10'd0;
else
vcount<= vcount +10'd1; //场扫描计数器加 1
end
end
assign vcount_ov = (vcount == vline_end); //场计数器=524，一帧显示结束，给
//数据、同步信号输出
assign data_act = ((hcount>=hdata_begin-2) &&
(hcount<hdata_end))&&((vcount>=vdata_begin-2)&& (vcount<vdata_end)); //显示阶

always@(posedge clock)
begin
 hsync <= (hcount > hsync_end);//行计数器大于 95，行同步信号置 1
 vsync <= (vcount > vsync_end); //场计数器大于 1，场同步信号置 1
end
reg [3:0] datar;reg [3:0] datag;reg [3:0] datab;

always@(posedge clock)
begin
 red[3:0] <= (data_act) ? datar : 4'b0000;//显示阶段，输出数据，否则输8
 green[3:0] <= (data_act) ? datag : 4'b0000;//显示阶段，输出数据，否则输8
 blue [3:0]<= (data_act) ? datab : 4'b0000;//显示阶段，输出数据，否则输8
end
reg [15:0] addra = 16'b0;
wire [15:0] douta;
pic start(
    .addra(addra),
    .clka(clock),
    .douta(douta)
    );
    reg [15:0] xiaodou;//移动消抖
    always@(posedge clock)
    begin 
    xiaodou[3:0] <= {xiaodou[2:0],yidong[0]};
    xiaodou[7:4] <= {xiaodou[6:4],yidong[1]};
    xiaodou[11:8] <= {xiaodou[10:8],yidong[2]};
    xiaodou[15:12] <= {xiaodou[14:12],yidong[3]};
    end
    
    wire [3:0] yidongend;
    assign yidongend[0] = (xiaodou[3:0]==4'b1111)?1:0; //shang
     assign yidongend[1] = (xiaodou[7:4]==4'b1111)?1:0; //xia
      assign yidongend[2] = (xiaodou[11:8]==4'b1111)?1:0;//zuo
       assign yidongend[3] = (xiaodou[15:12]==4'b1111)?1:0;//you
       
       reg[8:0] h = 143;reg[8:0] v = 34;  //控制移动和移动速度
       always@(posedge clock )
       begin
       if(vcount == 6&hcount ==6)
       begin
       if(h>=583&&yidongend[3]==1)
       h<=583;
       else if(h==143&&yidongend[2]==1)
       h<=143;
       else if(yidongend[3] == 1&&yidongend[2] ==0)
       h<=h+1;
       else if(yidongend[2] == 1&&yidongend[3] ==0)
       h<=h-1;
       end
       end
       always@(posedge clock)
       begin
       if(vcount ==6 & hcount ==6)
       begin
       if(v==314&&yidongend[1]==1)
       v<=314;
       else if(v==34&&yidongend[0]==1)
       v<=34;
       else if(yidongend[1] == 1&&yidongend[0] ==0)
       v<=v+1;
       else if(yidongend[0] == 1&&yidongend[1] ==0)
       v<=v-1;
       end
      end
always@(posedge clock) 
begin
if(addra == 39999)addra = 0;
 else if(hcount>=(h-2)&&hcount<(h+198)&&vcount>=(v-2)&&vcount<(v+198))
    begin 
      datar =douta[15:12];datag<=douta[10:7];datab[3:0]<=douta[4:1];addra <= addra+1;end
    else 
    begin 
   datar = 4'b1111;datag [3:0] = 4'b1001;datab [3:0] = 4'b0101;
    end
    end
endmodule
