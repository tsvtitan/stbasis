inherited fmEditRBSync_Package: TfmEditRBSync_Package
  Left = 397
  Top = 231
  Caption = 'fmEditRBSync_Package'
  ClientHeight = 114
  ClientWidth = 321
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 7
    Top = 13
    Width = 79
    Height = 13
    Caption = 'Наименование:'
    FocusControl = edName
  end
  object lbNote: TLabel [1]
    Left = 33
    Top = 39
    Width = 53
    Height = 13
    Caption = 'Описание:'
    FocusControl = edNote
  end
  inherited pnBut: TPanel
    Top = 76
    Width = 321
    TabOrder = 3
    inherited Panel2: TPanel
      Left = 136
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 60
    TabOrder = 2
  end
  object edName: TEdit [4]
    Left = 92
    Top = 9
    Width = 222
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edNote: TEdit [5]
    Left = 92
    Top = 35
    Width = 222
    Height = 21
    MaxLength = 250
    TabOrder = 1
    OnChange = edNameChange
  end
  inherited IBTran: TIBTransaction
    Left = 34
    Top = 9
  end
end
