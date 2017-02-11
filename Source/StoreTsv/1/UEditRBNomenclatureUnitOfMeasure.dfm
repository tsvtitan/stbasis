inherited fmEditRBNomenclatureUnitOfMeasure: TfmEditRBNomenclatureUnitOfMeasure
  Left = 357
  Top = 244
  Caption = 'fmEditRBNomenclatureUnitOfMeasure'
  ClientHeight = 187
  ClientWidth = 331
  PixelsPerInch = 96
  TextHeight = 13
  object lbCode: TLabel [0]
    Left = 63
    Top = 61
    Width = 55
    Height = 13
    Caption = 'Штрих код:'
  end
  object lbUnit: TLabel [1]
    Left = 13
    Top = 15
    Width = 105
    Height = 13
    Caption = 'Единица измерения:'
  end
  object lbWeigth: TLabel [2]
    Left = 217
    Top = 87
    Width = 22
    Height = 13
    Caption = 'Вес:'
  end
  object lbCalcFactor: TLabel [3]
    Left = 111
    Top = 114
    Width = 128
    Height = 13
    Caption = 'Коэффициент пересчета:'
  end
  inherited pnBut: TPanel
    Top = 149
    Width = 331
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 146
    end
  end
  inherited cbInString: TCheckBox
    Top = 133
    TabOrder = 6
  end
  object edCode: TEdit [6]
    Left = 123
    Top = 57
    Width = 198
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edCodeChange
  end
  object edUnit: TEdit [7]
    Left = 124
    Top = 11
    Width = 177
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edCodeChange
  end
  object bibUnit: TBitBtn [8]
    Left = 301
    Top = 11
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibUnitClick
  end
  object chbIsBaseUnit: TCheckBox [9]
    Left = 123
    Top = 36
    Width = 150
    Height = 17
    Caption = 'Это базовая единица'
    TabOrder = 2
    OnClick = chbIsBaseUnitClick
  end
  object edWeigth: TEdit [10]
    Left = 248
    Top = 83
    Width = 74
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 4
    Text = '0'
    OnKeyPress = edWeigthKeyPress
  end
  object edCalcFactor: TEdit [11]
    Left = 248
    Top = 110
    Width = 74
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 5
    Text = '1'
    OnKeyPress = edWeigthKeyPress
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 89
  end
end
