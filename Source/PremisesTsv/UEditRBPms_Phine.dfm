inherited fmEditRBPms_Phone: TfmEditRBPms_Phone
  Caption = 'fmEditRBPms_Phone'
  ClientHeight = 130
  ClientWidth = 309
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 20
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Наименование:'
  end
  object lbNote: TLabel [1]
    Left = 34
    Top = 47
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Описание:'
  end
  inherited pnBut: TPanel
    Top = 92
    Width = 309
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 124
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 73
    TabOrder = 2
  end
  object edName: TEdit [4]
    Left = 97
    Top = 16
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edNote: TEdit [5]
    Left = 97
    Top = 43
    Width = 199
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
