inherited fmEditRBAnnStreetTree: TfmEditRBAnnStreetTree
  Left = 297
  Top = 242
  Caption = 'fmEditRBAnnStreetTree'
  ClientHeight = 114
  ClientWidth = 287
  PixelsPerInch = 96
  TextHeight = 13
  object lbTreeHeading: TLabel [0]
    Left = 19
    Top = 11
    Width = 45
    Height = 13
    Caption = 'Рубрика:'
    FocusControl = edTreeHeading
  end
  object lbStreet: TLabel [1]
    Left = 27
    Top = 38
    Width = 35
    Height = 13
    Caption = 'Улица:'
    FocusControl = edStreet
  end
  inherited pnBut: TPanel
    Top = 76
    Width = 287
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 102
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 60
    TabOrder = 4
  end
  object edTreeHeading: TEdit [4]
    Left = 74
    Top = 7
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edWordChange
  end
  object bibTreeHeading: TButton [5]
    Left = 259
    Top = 7
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibTreeHeadingClick
  end
  object edStreet: TEdit [6]
    Left = 74
    Top = 34
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edWordChange
  end
  object bibStreet: TButton [7]
    Left = 259
    Top = 34
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibStreetClick
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 81
  end
end
