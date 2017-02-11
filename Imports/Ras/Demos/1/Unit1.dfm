object Form1: TForm1
  Left = 586
  Top = 308
  Width = 231
  Height = 291
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 31
    Height = 13
    Caption = 'Phone'
  end
  object Label2: TLabel
    Left = 32
    Top = 48
    Width = 22
    Height = 13
    Caption = 'User'
  end
  object Label3: TLabel
    Left = 32
    Top = 72
    Width = 23
    Height = 13
    Caption = 'Pass'
  end
  object edPhone: TEdit
    Left = 75
    Top = 20
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'P651031'
  end
  object edUser: TEdit
    Left = 75
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '0215338'
  end
  object edPass: TEdit
    Left = 75
    Top = 68
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '271289'
  end
  object Dial: TButton
    Left = 120
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Dial'
    TabOrder = 3
    OnClick = DialClick
  end
  object Memo1: TMemo
    Left = 24
    Top = 104
    Width = 177
    Height = 73
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object Create: TButton
    Left = 24
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Create'
    TabOrder = 5
    OnClick = CreateClick
  end
  object Dialog: TButton
    Left = 72
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Dialog'
    TabOrder = 6
    OnClick = DialogClick
  end
end
