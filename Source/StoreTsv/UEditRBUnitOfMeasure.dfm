inherited fmEditRBUnitOfMeasure: TfmEditRBUnitOfMeasure
  Caption = 'fmEditRBUnitOfMeasure'
  ClientHeight = 152
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 20
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbShortName: TLabel [1]
    Left = 42
    Top = 47
    Width = 45
    Height = 13
    Caption = 'Краткое:'
  end
  object lbOkei: TLabel [2]
    Left = 17
    Top = 75
    Width = 70
    Height = 13
    Caption = 'Код по ОКЕИ:'
  end
  inherited pnBut: TPanel
    Top = 114
    Width = 309
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 97
    TabOrder = 3
  end
  object edName: TEdit [5]
    Left = 97
    Top = 16
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edShortName: TEdit [6]
    Left = 97
    Top = 43
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object edOkei: TEdit [7]
    Left = 97
    Top = 71
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 216
    Top = 33
  end
end
