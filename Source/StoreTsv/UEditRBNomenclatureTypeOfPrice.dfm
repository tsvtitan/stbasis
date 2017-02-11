inherited fmEditRBNomenclatureTypeOfPrice: TfmEditRBNomenclatureTypeOfPrice
  Left = 579
  Top = 216
  Caption = 'fmEditRBNomenclatureTypeOfPrice'
  ClientHeight = 195
  ClientWidth = 331
  PixelsPerInch = 96
  TextHeight = 13
  object lbUnit: TLabel [0]
    Left = 12
    Top = 43
    Width = 105
    Height = 13
    Caption = 'Единица измерения:'
  end
  object lbPay: TLabel [1]
    Left = 177
    Top = 100
    Width = 47
    Height = 13
    Caption = 'Наценка:'
  end
  object lbPrice: TLabel [2]
    Left = 195
    Top = 127
    Width = 29
    Height = 13
    Caption = 'Цена:'
  end
  object lbTypeOfPrice: TLabel [3]
    Left = 66
    Top = 15
    Width = 51
    Height = 13
    Caption = 'Тип цены:'
  end
  object lbCurrency: TLabel [4]
    Left = 76
    Top = 72
    Width = 41
    Height = 13
    Caption = 'Валюта:'
  end
  inherited pnBut: TPanel
    Top = 157
    Width = 331
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 146
    end
  end
  inherited cbInString: TCheckBox
    Top = 141
    TabOrder = 8
  end
  object edUnit: TEdit [7]
    Left = 124
    Top = 39
    Width = 177
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edCodeChange
  end
  object bibUnit: TBitBtn [8]
    Left = 301
    Top = 39
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = bibUnitClick
  end
  object edPay: TEdit [9]
    Left = 232
    Top = 96
    Width = 90
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 6
    Text = '0'
    OnChange = edCodeChange
    OnKeyPress = edPayKeyPress
  end
  object edPrice: TEdit [10]
    Left = 232
    Top = 123
    Width = 90
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 7
    Text = '0'
    OnChange = edCodeChange
    OnKeyPress = edPayKeyPress
  end
  object edTypeOfPrice: TEdit [11]
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
  object bibTypeOfPrice: TBitBtn [12]
    Left = 301
    Top = 11
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibTypeOfPriceClick
  end
  object edCurrency: TEdit [13]
    Left = 124
    Top = 68
    Width = 177
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edCodeChange
  end
  object bibCurrency: TBitBtn [14]
    Left = 301
    Top = 68
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 5
    OnClick = bibCurrencyClick
  end
  inherited IBTran: TIBTransaction
    Left = 24
    Top = 65
  end
end
