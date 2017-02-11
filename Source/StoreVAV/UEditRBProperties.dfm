inherited fmEditRBProperties: TfmEditRBProperties
  Left = 278
  Top = 255
  Caption = 'Значения свойств'
  ClientHeight = 234
  ClientWidth = 353
  PixelsPerInch = 96
  TextHeight = 13
  object lbProperties: TLabel [0]
    Left = 63
    Top = 38
    Width = 51
    Height = 13
    Caption = 'Свойства:'
  end
  object lbAbout: TLabel [1]
    Left = 47
    Top = 60
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  object lbParent: TLabel [2]
    Left = 63
    Top = 11
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = 'Родитель:'
  end
  inherited pnBut: TPanel
    Top = 196
    Width = 353
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 168
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 178
    TabOrder = 4
  end
  object edNameProperties: TEdit [5]
    Left = 124
    Top = 34
    Width = 221
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edNamePropertiesChange
  end
  object meAbout: TMemo [6]
    Left = 124
    Top = 58
    Width = 221
    Height = 119
    TabOrder = 3
    OnChange = edNamePropertiesChange
  end
  object edParentProperties: TEdit [7]
    Left = 124
    Top = 8
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnKeyDown = edParentPropertiesKeyDown
  end
  object bibParentProperties: TBitBtn [8]
    Left = 324
    Top = 7
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibParentPropertiesClick
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 105
  end
end
