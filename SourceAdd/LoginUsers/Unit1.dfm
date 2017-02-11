object Form1: TForm1
  Left = 223
  Top = 106
  Width = 696
  Height = 480
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
  object Memo1: TMemo
    Left = 40
    Top = 16
    Width = 329
    Height = 353
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 456
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Users'
    TabOrder = 1
    OnClick = Button1Click
  end
  object IBDatabaseInfo1: TIBDatabaseInfo
    Database = IBDatabase1
    Left = 400
    Top = 32
  end
  object IBDatabase1: TIBDatabase
    DatabaseName = 'C:\1STBASIS\Data\STBASIS.GDB'
    Params.Strings = (
      'user_name=adminuser'
      'password=adminuser'
      'lc_ctype=WIN1251')
    LoginPrompt = False
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 392
    Top = 80
  end
end
