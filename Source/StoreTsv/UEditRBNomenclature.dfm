inherited fmEditRBNomenclature: TfmEditRBNomenclature
  Left = 382
  Top = 189
  ActiveControl = edNum
  Caption = 'fmEditRBNomenclature'
  ClientHeight = 239
  ClientWidth = 487
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 49
    Top = 39
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbNdsRate: TLabel [1]
    Left = 348
    Top = 139
    Width = 66
    Height = 13
    Caption = 'Ставка НДС:'
  end
  object lbNpRate: TLabel [2]
    Left = 356
    Top = 165
    Width = 58
    Height = 13
    Caption = 'Ставка НП:'
  end
  object lbNum: TLabel [3]
    Left = 339
    Top = 14
    Width = 37
    Height = 13
    Caption = 'Номер:'
  end
  object lbFullName: TLabel [4]
    Left = 10
    Top = 64
    Width = 118
    Height = 13
    Caption = 'Полное наименование:'
  end
  object lbGroup: TLabel [5]
    Left = 90
    Top = 12
    Width = 38
    Height = 13
    Caption = 'Группа:'
  end
  object lbArticle: TLabel [6]
    Left = 84
    Top = 89
    Width = 44
    Height = 13
    Caption = 'Артикул:'
  end
  object lbOkdp: TLabel [7]
    Left = 313
    Top = 89
    Width = 35
    Height = 13
    Caption = 'ОКДП:'
  end
  object lbViewOfGoods: TLabel [8]
    Left = 68
    Top = 113
    Width = 60
    Height = 13
    Caption = 'Вид товара:'
  end
  object lbTypeOfGoods: TLabel [9]
    Left = 289
    Top = 113
    Width = 60
    Height = 13
    Caption = 'Тип товара:'
  end
  object lbGtdNum: TLabel [10]
    Left = 103
    Top = 138
    Width = 25
    Height = 13
    Caption = 'ГТД:'
  end
  object lbCountryName: TLabel [11]
    Left = 9
    Top = 164
    Width = 119
    Height = 13
    Caption = 'Страна производитель:'
  end
  inherited pnBut: TPanel
    Top = 201
    Width = 487
    TabOrder = 16
    inherited Panel2: TPanel
      Left = 302
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 185
    TabOrder = 15
  end
  object edName: TEdit [14]
    Left = 135
    Top = 35
    Width = 344
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edNameChange
  end
  object edNdsRate: TEdit [15]
    Left = 421
    Top = 135
    Width = 59
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 11
    Text = '0'
    OnChange = edNameChange
    OnKeyPress = edNpRateKeyPress
  end
  object edNpRate: TEdit [16]
    Left = 421
    Top = 161
    Width = 59
    Height = 21
    BiDiMode = bdRightToLeft
    MaxLength = 15
    ParentBiDiMode = False
    TabOrder = 14
    Text = '0'
    OnChange = edNameChange
    OnKeyPress = edNpRateKeyPress
  end
  object edNum: TEdit [17]
    Left = 383
    Top = 10
    Width = 96
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edNameChange
  end
  object edFullName: TEdit [18]
    Left = 135
    Top = 60
    Width = 344
    Height = 21
    MaxLength = 100
    TabOrder = 4
    OnChange = edNameChange
  end
  object edGroup: TEdit [19]
    Left = 135
    Top = 9
    Width = 174
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edNameChange
  end
  object bibGroup: TBitBtn [20]
    Left = 309
    Top = 9
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibGroupClick
  end
  object edArticle: TEdit [21]
    Left = 135
    Top = 85
    Width = 168
    Height = 21
    MaxLength = 100
    TabOrder = 5
    OnChange = edNameChange
  end
  object edOkdp: TEdit [22]
    Left = 355
    Top = 85
    Width = 124
    Height = 21
    MaxLength = 100
    TabOrder = 6
    OnChange = edNameChange
  end
  object cmbViewOfGoods: TComboBox [23]
    Left = 135
    Top = 110
    Width = 144
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    OnChange = edNameChange
    Items.Strings = (
      'Товар'
      'Услуга'
      'Набор')
  end
  object cmbTypeOfGoods: TComboBox [24]
    Left = 355
    Top = 110
    Width = 125
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    OnChange = edNameChange
    Items.Strings = (
      'Штучный'
      'Весовой')
  end
  object edGtdNum: TEdit [25]
    Left = 135
    Top = 135
    Width = 179
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 9
    OnChange = edNameChange
    OnKeyDown = edGtdNumKeyDown
  end
  object bibGtdNum: TBitBtn [26]
    Left = 314
    Top = 135
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 10
    OnClick = bibGtdNumClick
  end
  object edCountryName: TEdit [27]
    Left = 135
    Top = 161
    Width = 179
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 12
    OnChange = edNameChange
  end
  object bibCountryName: TBitBtn [28]
    Left = 314
    Top = 161
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 13
    OnClick = bibCountryNameClick
  end
  inherited IBTran: TIBTransaction
    Left = 11
    Top = 106
  end
end
