object Form1: TForm1
  Left = 192
  Top = 126
  Width = 435
  Height = 263
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object IdFingerServer1: TIdFingerServer
    Active = True
    Bindings = <
      item
        Port = 79
      end>
    DefaultPort = 79
    OnCommandFinger = IdFingerServer1CommandFinger
    OnCommandVerboseFinger = IdFingerServer1CommandVerboseFinger
    Left = 128
    Top = 48
  end
end
