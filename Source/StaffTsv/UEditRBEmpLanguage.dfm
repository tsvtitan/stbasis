inherited fmEditRBEmpLanguage: TfmEditRBEmpLanguage
  Caption = 'fmEditRBEmpLanguage'
  ClientHeight = 118
  ClientWidth = 292
  PixelsPerInch = 96
  TextHeight = 13
  object lbLanguage: TLabel [0]
    Left = 65
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Язык:'
  end
  object lbKnowLevel: TLabel [1]
    Left = 10
    Top = 42
    Width = 86
    Height = 13
    Caption = 'Уровень знания:'
  end
  inherited pnBut: TPanel
    Top = 80
    Width = 292
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 107
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 64
    TabOrder = 4
  end
  object edLanguage: TEdit [4]
    Left = 102
    Top = 14
    Width = 159
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edLanguageChange
  end
  object bibLanguage: TBitBtn [5]
    Left = 261
    Top = 14
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibLanguageClick
  end
  object edKnowLevel: TEdit [6]
    Left = 102
    Top = 40
    Width = 159
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edLanguageChange
  end
  object bibKnowLevel: TBitBtn [7]
    Left = 261
    Top = 40
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibKnowLevelClick
  end
  inherited IBTran: TIBTransaction
    Left = 96
    Top = 89
  end
end
