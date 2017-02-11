inherited fmEditRBChargeTree: TfmEditRBChargeTree
  Left = 304
  Caption = 'fmEditRBChargeTree'
  ClientHeight = 115
  ClientWidth = 301
  PixelsPerInch = 96
  TextHeight = 13
  object lbParent: TLabel [0]
    Left = 24
    Top = 41
    Width = 51
    Height = 13
    Caption = 'Родитель:'
  end
  object lbName: TLabel [1]
    Left = 11
    Top = 14
    Width = 64
    Height = 13
    Caption = 'Начисление:'
  end
  inherited pnBut: TPanel
    Top = 77
    Width = 301
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 116
    end
  end
  inherited cbInString: TCheckBox
    Left = 7
    Top = 61
    TabOrder = 4
  end
  object edParent: TEdit [4]
    Left = 85
    Top = 37
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edNameChange
    OnKeyDown = edParentKeyDown
  end
  object bibParent: TBitBtn [5]
    Left = 270
    Top = 37
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibParentClick
  end
  object edName: TEdit [6]
    Left = 85
    Top = 10
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNameChange
    OnKeyDown = edParentKeyDown
  end
  object bibName: TBitBtn [7]
    Left = 270
    Top = 10
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibNameClick
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 81
  end
end
