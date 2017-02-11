inherited fmEditRBLanguage: TfmEditRBLanguage
  Caption = 'fmEditRBLanguage'
  ClientHeight = 101
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 20
    Width = 101
    Height = 13
    Caption = 'Иностранный язык:'
  end
  inherited pnBut: TPanel
    Top = 63
    Width = 309
    TabOrder = 2
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Top = 45
  end
  object edName: TEdit [3]
    Left = 117
    Top = 16
    Width = 180
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 216
    Top = 33
  end
end
