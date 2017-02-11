object Form1: TForm1
  Left = 234
  Top = 141
  Width = 783
  Height = 540
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
  object Button1: TButton
    Left = 408
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object IBDatabase1: TIBDatabase
    Connected = True
    DatabaseName = 'E:\Work\1STBASIS\Data\STBASIS.GDB'
    Params.Strings = (
      'user_name=adminuser'
      'password=adminuser'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    DefaultTransaction = IBTransaction2
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 176
    Top = 96
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1001
    OnTimer = Timer1Timer
    Left = 96
    Top = 88
  end
  object IBTransaction2: TIBTransaction
    Active = True
    DefaultDatabase = IBDatabase1
    AutoStopAction = saNone
    Left = 264
    Top = 112
  end
  object qr: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction2
    BufferChunks = 1000
    CachedUpdates = False
    Left = 112
    Top = 192
  end
end
