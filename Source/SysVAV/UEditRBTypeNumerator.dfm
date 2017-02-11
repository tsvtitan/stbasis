inherited fmEditRBTypeNumerator: TfmEditRBTypeNumerator
  Left = 336
  Top = 286
  Caption = 'fmEditRBTypeNumerator'
  ClientHeight = 206
  ClientWidth = 373
  PixelsPerInch = 96
  TextHeight = 13
  object lbNameTypeNumerator: TLabel [0]
    Left = 26
    Top = 11
    Width = 85
    Height = 13
    Alignment = taRightJustify
    Caption = 'Тип нумератора:'
  end
  object lbAbout: TLabel [1]
    Left = 47
    Top = 32
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  inherited pnBut: TPanel
    Top = 168
    Width = 373
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 188
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 146
    TabOrder = 2
  end
  object edNameTypeNumerator: TEdit [4]
    Left = 124
    Top = 7
    Width = 245
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameTypeNumeratorChange
  end
  object meAbout: TMemo [5]
    Left = 124
    Top = 30
    Width = 245
    Height = 113
    TabOrder = 1
    OnChange = edNameTypeNumeratorChange
  end
  inherited IBTran: TIBTransaction
    Left = 0
    Top = 1
  end
end
