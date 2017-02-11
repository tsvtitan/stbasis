object Form1: TForm1
  Left = 542
  Top = 364
  Width = 286
  Height = 177
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
  object lbUser: TLabel
    Left = 15
    Top = 15
    Width = 95
    Height = 13
    Caption = 'Пользователь БД:'
  end
  object lbPass: TLabel
    Left = 69
    Top = 45
    Width = 41
    Height = 13
    Caption = 'Пароль:'
  end
  object edPass: TEdit
    Left = 117
    Top = 42
    Width = 150
    Height = 21
    MaxLength = 20
    PasswordChar = '*'
    TabOrder = 0
  end
  object edUser: TEdit
    Left = 117
    Top = 10
    Width = 150
    Height = 21
    MaxLength = 20
    PasswordChar = '*'
    TabOrder = 1
  end
end
