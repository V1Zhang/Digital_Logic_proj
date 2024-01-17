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
  input wire key,
  input wire replay,
  input wire save,
  input wire delete,
  input wire override
  
  
);

// Constants
parameter MAX_RECORD_LENGTH = 300; 
parameter MAX_SAVED_RECORDS = 10; 

wire clk_20ms;
wire key_pulse;
divclk_20ms div(clk,rst,clk_20ms);
debounce_button b(clk_20ms,rst,key,key_pulse);

  // Internal signals
  reg [7:0] recorded_data [0:MAX_RECORD_LENGTH-1];
  reg [7:0] saved_records [0:MAX_SAVED_RECORDS-1];
  reg [3:0] record_length;
  reg [3:0] saved_records_count;
  reg [3:0] playback_index;
  reg recording;
  reg replaying;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      recording <= 0;
      replaying <= 0;
      record_length <= 0;
      saved_records_count <= 0;
      playback_index <= 0;
    end else begin
      // �û�������
      if (start_record && ~recording) begin
        recording <= 1;
        record_length <= 0;
      end

      if (stop_record && recording) begin
        recording <= 0;
        // ����¼��
        if (record_length > 0 && saved_records_count < MAX_SAVED_RECORDS) begin
          saved_records[saved_records_count] <= record_length;
          saved_records_count <= saved_records_count + 1;
        end
      end

      if (replay) begin
        replaying <= 1;
        playback_index <= 0;
      end

      if (confirm_save) begin
        // ����ǰ¼������
        if (record_length > 0 && saved_records_count < MAX_SAVED_RECORDS) begin
          saved_records[saved_records_count] <= record_length;
          saved_records_count <= saved_records_count + 1;
        end
      end

      if (delete_saved_record) begin
        // ɾ������ļ�¼
        if (saved_records_count > 0) begin
          saved_records_count <= saved_records_count - 1;
        end
      end

      if (override_saved_record) begin
        // ���Ǳ���ļ�¼
        if (record_length > 0 && saved_records_count > 0) begin
          saved_records[saved_records_count - 1] <= record_length;
        end
      end

      // ¼���ͻط��߼�
      if (recording) begin
        recorded_data[record_length] <= /* your input data */;
        record_length <= record_length + 1;
      end

      if (replaying) begin
        // �ط��߼�
        // ������Ҫ������Ҫ����ط��߼������� playback_index ���ʱ���ļ�¼��ģ���û�����
        // ע�⣺������Ҫ����ʱ����ƣ�ȷ����ȷ��ʱ��
      end
    end
  end

endmodule

