inherited fmEditDocWarrant: TfmEditDocWarrant
  Left = 402
  Top = 283
  ActiveControl = bibNomenclature
  Caption = 'fmEditDocWarrant'
  ClientHeight = 161
  ClientWidth = 341
  PixelsPerInch = 96
  TextHeight = 13
  object lbNomenclature: TLabel [0]
    Left = 35
    Top = 12
    Width = 77
    Height = 13
    Caption = 'Номенклатура:'
  end
  object lbUnitOfMeasure: TLabel [1]
    Left = 7
    Top = 39
    Width = 105
    Height = 13
    Caption = 'Единица измерения:'
  end
  object lbAmount: TLabel [2]
    Left = 167
    Top = 94
    Width = 62
    Height = 13
    Caption = 'Количество:'
  end
  object lbCalcFactor: TLabel [3]
    Left = 101
    Top = 67
    Width = 128
    Height = 13
    Caption = 'Коэффициент пересчета:'
  end
  inherited pnBut: TPanel
    Top = 123
    Width = 341
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 156
    end
  end
  inherited cbInString: TCheckBox
    Top = 107
    TabOrder = 6
  end
  object edNomenclature: TEdit [6]
    Left = 121
    Top = 9
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNomenclatureChange
  end
  object edUnitOfMeasure: TEdit [7]
    Left = 121
    Top = 36
    Width = 190
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edNomenclatureChange
  end
  object bibNomenclature: TBitBtn [8]
    Left = 311
    Top = 9
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibNomenclatureClick
  end
  object bibUnitOfMeasure: TBitBtn [9]
    Left = 311
    Top = 36
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = bibUnitOfMeasureClick
  end
  object edAmount: TEdit [10]
    Left = 238
    Top = 90
    Width = 94
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 5
    Text = '1'
    OnKeyPress = edCalcFactorKeyPress
  end
  object edCalcFactor: TEdit [11]
    Left = 238
    Top = 63
    Width = 94
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 4
    Text = '1'
    OnKeyPress = edCalcFactorKeyPress
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 65
  end
end
