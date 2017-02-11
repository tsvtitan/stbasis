object Form1: TForm1
  Left = 163
  Top = 181
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
  object DBGrid1: TDBGrid
    Left = 32
    Top = 160
    Width = 673
    Height = 289
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 488
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Pump'
    TabOrder = 1
    OnClick = Button1Click
  end
  object IBDatabase1: TIBDatabase
    Connected = True
    DatabaseName = 'D:\Work\1STBASIS\Data\STBASIS.GDB'
    Params.Strings = (
      'user_name=adminuser'
      'password=adminuser'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 80
    Top = 40
  end
  object IBTransaction1: TIBTransaction
    Active = False
    DefaultDatabase = IBDatabase1
    Left = 168
    Top = 24
  end
  object qr: TIBQuery
    Database = IBDatabase1
    Transaction = IBTransaction1
    BufferChunks = 1000
    CachedUpdates = False
    Left = 120
    Top = 96
  end
  object Query1: TQuery
    Active = True
    DatabaseName = 'STANDARD1'
    SQL.Strings = (
      'select count(distinct(name)) from rus_word')
    Left = 352
    Top = 64
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 264
    Top = 48
  end
end
