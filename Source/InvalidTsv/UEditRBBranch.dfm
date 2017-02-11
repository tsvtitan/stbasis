inherited fmEditRBBranch: TfmEditRBBranch
  Top = 303
  Caption = 'fmEditRBBranch'
  ClientHeight = 90
  ClientWidth = 304
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 13
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  inherited pnBut: TPanel
    Top = 52
    Width = 304
    TabOrder = 2
    inherited Panel2: TPanel
      Left = 119
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 34
  end
  object edName: TEdit [3]
    Left = 97
    Top = 9
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 10
  end
end
