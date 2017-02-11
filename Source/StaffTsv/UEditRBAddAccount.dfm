inherited fmEditRBAddAccount: TfmEditRBAddAccount
  Left = 202
  Top = 124
  Caption = 'fmEditRBAddAccount'
  ClientHeight = 115
  ClientWidth = 341
  PixelsPerInch = 96
  TextHeight = 13
  object lbAccount: TLabel [0]
    Left = 29
    Top = 14
    Width = 83
    Height = 13
    Caption = 'Расчетный счет:'
  end
  object lbBank: TLabel [1]
    Left = 84
    Top = 41
    Width = 28
    Height = 13
    Caption = 'Банк:'
  end
  inherited pnBut: TPanel
    Top = 77
    Width = 341
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 156
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 62
    TabOrder = 3
  end
  object edAccount: TEdit [4]
    Left = 120
    Top = 11
    Width = 133
    Height = 21
    MaxLength = 30
    TabOrder = 0
    OnChange = edInnChange
    OnKeyPress = edInnKeyPress
  end
  object edBank: TEdit [5]
    Left = 120
    Top = 38
    Width = 189
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edInnChange
  end
  object bibBank: TBitBtn [6]
    Left = 309
    Top = 38
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 2
    OnClick = bibBankClick
  end
  inherited IBTran: TIBTransaction
    Left = 120
    Top = 81
  end
end
