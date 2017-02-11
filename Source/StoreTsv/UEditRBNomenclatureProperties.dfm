inherited fmEditRBNomenclatureProperties: TfmEditRBNomenclatureProperties
  Left = 532
  Top = 255
  Caption = 'fmEditRBNomenclatureProperties'
  ClientHeight = 115
  ClientWidth = 279
  PixelsPerInch = 96
  TextHeight = 13
  object lbNameProperties: TLabel [0]
    Left = 12
    Top = 13
    Width = 51
    Height = 13
    Caption = 'Свойство:'
  end
  object lbValueProperties: TLabel [1]
    Left = 12
    Top = 39
    Width = 51
    Height = 13
    Caption = 'Значение:'
  end
  inherited pnBut: TPanel
    Top = 77
    Width = 279
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 94
    end
  end
  inherited cbInString: TCheckBox
    Top = 61
    TabOrder = 3
  end
  object edNameProperties: TEdit [4]
    Left = 72
    Top = 9
    Width = 198
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNamePropertiesChange
  end
  object edValueProperties: TEdit [5]
    Left = 72
    Top = 35
    Width = 177
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNamePropertiesChange
  end
  object bibValueProperties: TBitBtn [6]
    Left = 249
    Top = 35
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibValuePropertiesClick
  end
  inherited IBTran: TIBTransaction
    Left = 120
    Top = 17
  end
end
