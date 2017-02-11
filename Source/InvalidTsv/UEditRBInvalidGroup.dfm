inherited fmEditRBInvalidGroup: TfmEditRBInvalidGroup
  Top = 303
  Caption = 'fmEditRBInvalidGroup'
  ClientHeight = 163
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
  object lbShortName: TLabel [1]
    Left = 21
    Top = 37
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Примечание:'
  end
  inherited pnBut: TPanel
    Top = 125
    Width = 304
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 119
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 108
    TabOrder = 2
  end
  object edName: TEdit [4]
    Left = 97
    Top = 9
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object meNote: TMemo [5]
    Left = 97
    Top = 36
    Width = 199
    Height = 71
    ScrollBars = ssVertical
    TabOrder = 1
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 58
  end
end
