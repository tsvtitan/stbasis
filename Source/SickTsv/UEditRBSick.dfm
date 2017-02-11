inherited fmEditRBSick: TfmEditRBSick
  Caption = 'fmEditRBSick'
  ClientHeight = 118
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 17
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbCipher: TLabel [1]
    Left = 55
    Top = 44
    Width = 32
    Height = 13
    Caption = 'Шифр:'
  end
  inherited pnBut: TPanel
    Top = 80
    Width = 309
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 62
    TabOrder = 2
  end
  object edName: TEdit [4]
    Left = 97
    Top = 13
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edCipher: TEdit [5]
    Left = 97
    Top = 40
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 216
    Top = 30
  end
end
