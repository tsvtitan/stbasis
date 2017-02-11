inherited fmEditRBAnnStreet: TfmEditRBAnnStreet
  Left = 397
  Top = 231
  Caption = 'fmEditRBAnnStreet'
  ClientHeight = 91
  ClientWidth = 319
  PixelsPerInch = 96
  TextHeight = 13
  object lbWord: TLabel [0]
    Left = 8
    Top = 18
    Width = 34
    Height = 13
    Caption = 'Слово:'
    FocusControl = edWord
  end
  inherited pnBut: TPanel
    Top = 53
    Width = 319
    TabOrder = 2
    inherited Panel2: TPanel
      Left = 134
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 39
  end
  object edWord: TEdit [3]
    Left = 50
    Top = 14
    Width = 260
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edWordChange
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 49
  end
end
