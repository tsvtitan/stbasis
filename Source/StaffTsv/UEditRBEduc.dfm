inherited fmEditRBEduc: TfmEditRBEduc
  Caption = 'fmEditRBEduc'
  ClientHeight = 104
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 20
    Width = 91
    Height = 13
    Caption = 'Вид образования:'
  end
  inherited pnBut: TPanel
    Top = 66
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
    Left = 105
    Top = 16
    Width = 194
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
