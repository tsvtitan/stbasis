inherited fmEditRBAutoReplace: TfmEditRBAutoReplace
  Left = 345
  Top = 160
  Caption = 'fmEditRBAutoReplace'
  ClientHeight = 115
  ClientWidth = 294
  PixelsPerInch = 96
  TextHeight = 13
  object lbWhat: TLabel [0]
    Left = 5
    Top = 11
    Width = 105
    Height = 13
    Alignment = taRightJustify
    Caption = 'Что заменять (HEX):'
    FocusControl = edWhat
  end
  object lbOnWhat: TLabel [1]
    Left = 43
    Top = 38
    Width = 67
    Height = 13
    Alignment = taRightJustify
    Caption = 'На что (HEX):'
    FocusControl = edOnWhat
  end
  inherited pnBut: TPanel
    Top = 77
    Width = 294
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 109
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 58
    TabOrder = 2
  end
  object edWhat: TEdit [4]
    Left = 115
    Top = 7
    Width = 171
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edWhatChange
  end
  object edOnWhat: TEdit [5]
    Left = 115
    Top = 34
    Width = 171
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edWhatChange
  end
  inherited IBTran: TIBTransaction
    Left = 160
    Top = 9
  end
end
