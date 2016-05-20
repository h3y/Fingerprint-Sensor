object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Authentication'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object InitDeviceBtn: TButton
    Left = 56
    Top = 152
    Width = 105
    Height = 33
    Caption = 'Connect Sensor'
    TabOrder = 0
    OnClick = InitDeviceBtnClick
  end
  object SensorNum: TEdit
    Left = 80
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'SensorNum'
  end
  object PanelStatus: TPanel
    Left = 8
    Top = 8
    Width = 49
    Height = 49
    Color = clMenu
    ParentBackground = False
    TabOrder = 2
  end
  object SensorIndex: TEdit
    Left = 207
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'SensorIndex'
  end
  object SensorSN: TEdit
    Left = 80
    Top = 35
    Width = 248
    Height = 21
    TabOrder = 4
    Text = 'SensorSN'
  end
  object ZKFPEngX1: TZKFPEngX
    Left = 603
    Top = 267
    Width = 24
    Height = 24
    ControlData = {
      5450463008545A4B4650456E6700044C656674020003546F7002000557696474
      6802180648656967687402180B456E726F6C6C436F756E7402030B53656E736F
      72496E6465780200095468726573686F6C64020A114F6E65546F4F6E65546872
      6573686F6C64020A10466F7263655365636F6E644D61746368080C4175746F49
      64656E74696679080D4973496D6167654368616E6765080000}
  end
end
