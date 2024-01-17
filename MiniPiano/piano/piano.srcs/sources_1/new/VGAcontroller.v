
`timescale 1ns / 1ps
module VGAcontroller(
input clock, 
input rst,
output reg [3:0] red, // VGA 
output reg [3:0] green,
output reg [3:0] blue,
output reg hsync, // VGA Line synchronization signal
output reg vsync, // VGA Field synchronization signal
input [3:0]yidong
);
reg[9:0] hcount = 0; // Line synchronization counter
reg[9:0] vcount = 0; // Field synchronization counter
wire hcount_ov; //End of line scan flag bit
wire vcount_ov; //End of frame scan flag bit
wire data_act; //Display phase data is valid
//VGA Row and field scan timing parameter table
parameter hsync_end = 10'd95, //End of line synchronization signal (low level)
hdata_begin = 10'd143, //Line display start
hdata_end = 10'd783, //End of line display
hpixel_end = 10'd799, //The line shows the end of the delay
vsync_end = 10'd1, vdata_begin = 10'd34, vdata_end = 10'd514, vline_end =10'd524;
//VGA driver
//Line scan
always@(posedge clock)
begin
if(hcount_ov) //If the line scan flag bit is 1, the line is wrapped
hcount<=10'd0; //Set line scan counter to 0
else
hcount<= hcount +1; //Line scan counter +1
end
assign hcount_ov = (hcount == hpixel_end); //Line counter =799, end of scan line,
//Line scan flag bits are valid
always@(posedge clock)
begin
if(hcount_ov) //Line scan flag bits are valid
begin
if(vcount_ov) //Frame scan flag bit valid, field scan counter set to zero, re-count
vcount<=10'd0;
else
vcount<= vcount +10'd1; //Field scan counter plus 1
end
end
assign vcount_ov = (vcount == vline_end); //Field counter =524, one frame display end
//Data, synchronization signal output
assign data_act = ((hcount>=hdata_begin-2) &&
(hcount<hdata_end))&&((vcount>=vdata_begin-2)&& (vcount<vdata_end)); //Display level

always@(posedge clock)
begin
 hsync <= (hcount > hsync_end);//If the line counter is greater than 95, the line synchronization signal is set to 1
 vsync <= (vcount > vsync_end); //If the field counter is greater than 1, the field synchronization signal is set to 1
end
reg [3:0] datar;reg [3:0] datag;reg [3:0] datab;

always@(posedge clock)
begin
 red[3:0] <= (data_act) ? datar : 4'b0000;
 green[3:0] <= (data_act) ? datag : 4'b0000;
 blue [3:0]<= (data_act) ? datab : 4'b0000;
end
reg [15:0] addra = 16'b0;
wire [15:0] douta;
pic pic(
    .addra(addra),
    .clka(clock),
    .douta(douta)
    );
    reg [15:0] xiaodou;
    always@(posedge clock)
    begin 
    xiaodou[3:0] <= {xiaodou[2:0],yidong[0]};
    xiaodou[7:4] <= {xiaodou[6:4],yidong[1]};
    xiaodou[11:8] <= {xiaodou[10:8],yidong[2]};
    xiaodou[15:12] <= {xiaodou[14:12],yidong[3]};
    end
    
    wire [3:0] yidongend;
    assign yidongend[0] = (xiaodou[3:0]==4'b1111)?1:0; //up
     assign yidongend[1] = (xiaodou[7:4]==4'b1111)?1:0; //down
      assign yidongend[2] = (xiaodou[11:8]==4'b1111)?1:0;//left
       assign yidongend[3] = (xiaodou[15:12]==4'b1111)?1:0;//right
       
       reg[8:0] h = 143;reg[8:0] v = 34;  //Control movement and speed of movement
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
