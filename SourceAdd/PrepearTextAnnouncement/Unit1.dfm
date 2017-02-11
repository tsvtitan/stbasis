object Form1: TForm1
  Left = 314
  Top = 178
  Width = 701
  Height = 134
  Caption = 'Prepear'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 693
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 11
      Top = 14
      Width = 49
      Height = 13
      Caption = 'Database:'
    end
    object edDB: TEdit
      Left = 68
      Top = 11
      Width = 493
      Height = 21
      TabOrder = 0
    end
    object bibDB: TBitBtn
      Left = 571
      Top = 10
      Width = 22
      Height = 23
      Caption = '...'
      TabOrder = 1
      OnClick = bibDBClick
    end
    object bibConnect: TBitBtn
      Left = 603
      Top = 10
      Width = 70
      Height = 23
      Caption = 'Connect'
      TabOrder = 2
      OnClick = bibConnectClick
    end
  end
  object BitBtn1: TBitBtn
    Left = 176
    Top = 64
    Width = 345
    Height = 25
    Caption = 'Prepear'
    TabOrder = 1
    OnClick = BitBtn1Click
  end
  object od: TOpenDialog
    Left = 8
    Top = 56
  end
  object IBDB: TIBDatabase
    Params.Strings = (
      'lc_ctype=WIN1251')
    DefaultTransaction = IBTransaction1
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 56
    Top = 56
  end
  object IBTransaction1: TIBTransaction
    Active = False
    DefaultDatabase = IBDB
    AutoStopAction = saNone
    Left = 112
    Top = 64
  end
end
