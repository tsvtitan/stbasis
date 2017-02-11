object mainform: Tmainform
  Left = 269
  Top = 119
  Width = 303
  Height = 122
  Caption = 'Indy Linux Daemon Test Client'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 64
    Width = 157
    Height = 13
    Caption = 'Server will respond with "Indeed"'
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 22
    Height = 13
    Caption = 'Host'
  end
  object Button1: TButton
    Left = 8
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Send Test'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 48
    Top = 8
    Width = 177
    Height = 21
    TabOrder = 1
  end
  object myclient: TIdTCPClient
    Host = '172.31.247.3'
    Port = 9300
    Left = 224
    Top = 48
  end
end
