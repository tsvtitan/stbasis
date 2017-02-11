inherited fmEditRBSchool: TfmEditRBSchool
  Left = 304
  Caption = 'fmEditRBSchool'
  ClientHeight = 145
  ClientWidth = 311
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 16
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbParent: TLabel [1]
    Left = 36
    Top = 69
    Width = 51
    Height = 13
    Caption = 'Родитель:'
  end
  object lbTown: TLabel [2]
    Left = 54
    Top = 42
    Width = 33
    Height = 13
    Caption = 'Город:'
  end
  inherited pnBut: TPanel
    Top = 107
    Width = 311
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 126
    end
  end
  inherited cbInString: TCheckBox
    Top = 89
    TabOrder = 5
  end
  object edName: TEdit [5]
    Left = 93
    Top = 12
    Width = 205
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edParent: TEdit [6]
    Left = 93
    Top = 65
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
    OnChange = edNameChange
    OnKeyDown = edParentKeyDown
  end
  object bibParent: TBitBtn [7]
    Left = 278
    Top = 65
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 4
    OnClick = bibParentClick
  end
  object edTown: TEdit [8]
    Left = 93
    Top = 38
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameChange
    OnKeyDown = edParentKeyDown
  end
  object bibTown: TBitBtn [9]
    Left = 278
    Top = 38
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 2
    OnClick = bibTownClick
  end
  inherited IBTran: TIBTransaction
    Left = 104
  end
end
