inherited fmEditRBProfession: TfmEditRBProfession
  Caption = 'fmEditRBProfession'
  ClientHeight = 124
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 20
    Width = 81
    Height = 13
    Caption = 'Специальность:'
  end
  object lbCode: TLabel [1]
    Left = 67
    Top = 47
    Width = 22
    Height = 13
    Caption = 'Код:'
  end
  inherited pnBut: TPanel
    Top = 86
    Width = 309
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Top = 69
    TabOrder = 2
  end
  object edName: TEdit [4]
    Left = 96
    Top = 16
    Width = 202
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edCode: TEdit [5]
    Left = 96
    Top = 43
    Width = 105
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 216
    Top = 33
  end
end
