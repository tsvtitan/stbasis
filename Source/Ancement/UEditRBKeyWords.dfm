inherited fmEditRBKeyWords: TfmEditRBKeyWords
  Left = 297
  Top = 241
  Caption = 'fmEditRBKeyWords'
  ClientHeight = 114
  ClientWidth = 319
  PixelsPerInch = 96
  TextHeight = 13
  object lbTreeHeading: TLabel [0]
    Left = 49
    Top = 39
    Width = 45
    Height = 13
    Caption = 'Рубрика:'
    FocusControl = edTreeHeading
  end
  object lbWord: TLabel [1]
    Left = 8
    Top = 12
    Width = 86
    Height = 13
    Caption = 'Ключевое слово:'
    FocusControl = edWord
  end
  inherited pnBut: TPanel
    Top = 76
    Width = 319
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 134
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 60
    TabOrder = 3
  end
  object edTreeHeading: TEdit [4]
    Left = 104
    Top = 35
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edWordChange
  end
  object bibTreeHeading: TButton [5]
    Left = 289
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 2
    OnClick = bibTreeHeadingClick
  end
  object edWord: TEdit [6]
    Left = 104
    Top = 8
    Width = 206
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 100
    TabOrder = 0
    OnChange = edWordChange
    OnKeyPress = edWordKeyPress
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 81
  end
end
