object fmLoginDb: TfmLoginDb
  Left = 542
  Top = 364
  BorderStyle = bsDialog
  Caption = '�������� ������������'
  ClientHeight = 115
  ClientWidth = 278
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
    Caption = '������������ ��:'
  end
  object lbPass: TLabel
    Left = 69
    Top = 45
    Width = 41
    Height = 13
    Caption = '������:'
  end
  object edPass: TEdit
    Left = 117
    Top = 42
    Width = 150
    Height = 21
    MaxLength = 20
    PasswordChar = '*'
    TabOrder = 1
  end
  object edUser: TEdit
    Left = 117
    Top = 10
    Width = 150
    Height = 21
    MaxLength = 20
    PasswordChar = '*'
    TabOrder = 0
  end
  object pnBottom: TPanel
    Left = 0
    Top = 74
    Width = 278
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Panel: TPanel
      Left = 93
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TButton
        Left = 19
        Top = 8
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        Enabled = False
        TabOrder = 0
      end
      object bibCancel: TButton
        Left = 102
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = '������'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
end