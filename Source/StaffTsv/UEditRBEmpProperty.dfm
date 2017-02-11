inherited fmEditRBEmpProperty: TfmEditRBEmpProperty
  Caption = 'fmEditRBEmpProperty'
  ClientHeight = 93
  ClientWidth = 292
  PixelsPerInch = 96
  TextHeight = 13
  object lbProperty: TLabel [0]
    Left = 17
    Top = 17
    Width = 38
    Height = 13
    Caption = 'Группа:'
  end
  inherited pnBut: TPanel
    Top = 55
    Width = 292
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 107
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 40
    TabOrder = 2
  end
  object edProperty: TEdit [3]
    Left = 65
    Top = 14
    Width = 196
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edPropertyChange
  end
  object bibProperty: TBitBtn [4]
    Left = 261
    Top = 14
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPropertyClick
  end
  inherited IBTran: TIBTransaction
    Left = 88
    Top = 57
  end
end
