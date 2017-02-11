inherited fmEditRBValuesProperties: TfmEditRBValuesProperties
  Left = 393
  Top = 171
  Caption = 'fmEditRBRespondents'
  ClientHeight = 118
  ClientWidth = 345
  PixelsPerInch = 96
  TextHeight = 13
  object lbValueProperties: TLabel [0]
    Left = 12
    Top = 38
    Width = 101
    Height = 13
    Caption = 'Значение свойства:'
  end
  object lbParent: TLabel [1]
    Left = 62
    Top = 11
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Родитель:'
  end
  inherited pnBut: TPanel
    Top = 80
    Width = 345
    TabOrder = 1
    inherited Panel2: TPanel
      Left = 160
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 60
    TabOrder = 0
  end
  object edValueProperties: TEdit [4]
    Left = 117
    Top = 34
    Width = 221
    Height = 21
    MaxLength = 100
    TabOrder = 2
  end
  object edParentProperties: TEdit [5]
    Left = 118
    Top = 8
    Width = 198
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
    OnKeyDown = edParentPropertiesKeyDown
  end
  object bibParentProperties: TBitBtn [6]
    Left = 317
    Top = 7
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 4
    OnClick = bibParentPropertiesClick
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 1
  end
end
