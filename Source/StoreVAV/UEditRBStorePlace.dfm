inherited fmEditRBStorePlace: TfmEditRBStorePlace
  Left = 301
  Top = 231
  Caption = 'Значения свойств'
  ClientHeight = 277
  ClientWidth = 358
  PixelsPerInch = 96
  TextHeight = 13
  object lbNameStorePlace: TLabel [0]
    Left = 34
    Top = 14
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Наименование:'
  end
  object lbAbout: TLabel [1]
    Left = 47
    Top = 106
    Width = 66
    Height = 13
    Alignment = taRightJustify
    Caption = 'Примечание:'
  end
  object lbStoreType: TLabel [2]
    Left = 8
    Top = 35
    Width = 106
    Height = 13
    Alignment = taRightJustify
    Caption = 'Вид места хранения:'
  end
  object lbRespondents: TLabel [3]
    Left = 86
    Top = 59
    Width = 28
    Height = 13
    Alignment = taRightJustify
    Caption = 'МОЛ:'
  end
  object lbPlant: TLabel [4]
    Left = 24
    Top = 83
    Width = 90
    Height = 13
    Alignment = taRightJustify
    Caption = 'Принадлежность:'
  end
  inherited pnBut: TPanel
    Top = 239
    Width = 358
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 173
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 226
    TabOrder = 8
  end
  object edNameStorePlace: TEdit [7]
    Left = 124
    Top = 10
    Width = 221
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameStorePlaceChange
  end
  object meAbout: TMemo [8]
    Left = 124
    Top = 104
    Width = 221
    Height = 119
    TabOrder = 7
    OnChange = edNameStorePlaceChange
  end
  object edStoreType: TEdit [9]
    Left = 124
    Top = 32
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameStorePlaceChange
    OnKeyDown = edStoreTypeKeyDown
  end
  object bibStoreType: TBitBtn [10]
    Left = 324
    Top = 31
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 2
    OnClick = bibStoreTypeClick
  end
  object edRespondents: TEdit [11]
    Left = 124
    Top = 56
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
    OnChange = edNameStorePlaceChange
    OnKeyDown = edRespondentsKeyDown
  end
  object bibRespondents: TBitBtn [12]
    Left = 324
    Top = 55
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 4
    OnClick = bibRespondentsClick
  end
  object edPlant: TEdit [13]
    Left = 124
    Top = 80
    Width = 199
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 5
    OnChange = edNameStorePlaceChange
    OnKeyDown = edPlantKeyDown
  end
  object bibPlant: TBitBtn [14]
    Left = 324
    Top = 79
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 6
    OnClick = bibPlantClick
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 121
  end
end
