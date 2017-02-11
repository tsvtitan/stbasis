inherited fmEditRBPlant: TfmEditRBPlant
  Left = 202
  Top = 124
  Caption = 'fmEditRBPlant'
  ClientHeight = 315
  ClientWidth = 453
  PixelsPerInch = 96
  TextHeight = 13
  object lbJuristAddress: TLabel [0]
    Left = 24
    Top = 141
    Width = 104
    Height = 13
    Caption = 'Юридический адрес:'
  end
  object lbInn: TLabel [1]
    Left = 101
    Top = 14
    Width = 27
    Height = 13
    Caption = 'ИНН:'
  end
  object lbSmallName: TLabel [2]
    Left = 6
    Top = 64
    Width = 122
    Height = 13
    Caption = 'Краткое наименование:'
  end
  object lbFullName: TLabel [3]
    Left = 10
    Top = 89
    Width = 118
    Height = 13
    Caption = 'Полное наименование:'
  end
  object lbAccount: TLabel [4]
    Left = 45
    Top = 38
    Width = 83
    Height = 13
    Caption = 'Расчетный счет:'
  end
  object lbOkonh: TLabel [5]
    Left = 87
    Top = 115
    Width = 41
    Height = 13
    Caption = 'ОКОНХ:'
  end
  object lbOkpo: TLabel [6]
    Left = 224
    Top = 116
    Width = 34
    Height = 13
    Caption = 'ОКПО:'
  end
  object lbPostAddress: TLabel [7]
    Left = 42
    Top = 167
    Width = 86
    Height = 13
    Caption = 'Почтовый адрес:'
  end
  object lbBank: TLabel [8]
    Left = 100
    Top = 193
    Width = 28
    Height = 13
    Caption = 'Банк:'
  end
  object lbContactPeople: TLabel [9]
    Left = 37
    Top = 220
    Width = 91
    Height = 13
    Caption = 'Контактные лица:'
  end
  object lbPhone: TLabel [10]
    Left = 72
    Top = 244
    Width = 56
    Height = 13
    Caption = 'Телефоны:'
  end
  inherited pnBut: TPanel
    Top = 277
    Width = 453
    TabOrder = 14
    inherited Panel2: TPanel
      Left = 268
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 262
    TabOrder = 13
  end
  object edJuristAddress: TEdit [13]
    Left = 136
    Top = 138
    Width = 305
    Height = 21
    MaxLength = 100
    TabOrder = 7
    OnChange = edInnChange
  end
  object edInn: TEdit [14]
    Left = 136
    Top = 10
    Width = 73
    Height = 21
    MaxLength = 30
    TabOrder = 0
    OnChange = edInnChange
    OnKeyPress = edInnKeyPress
  end
  object edSmallName: TEdit [15]
    Left = 136
    Top = 61
    Width = 305
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edInnChange
  end
  object edFullName: TEdit [16]
    Left = 136
    Top = 86
    Width = 305
    Height = 21
    MaxLength = 30
    TabOrder = 4
    OnChange = edInnChange
  end
  object edAccount: TEdit [17]
    Left = 136
    Top = 35
    Width = 133
    Height = 21
    MaxLength = 30
    TabOrder = 1
    OnChange = edInnChange
    OnKeyPress = edInnKeyPress
  end
  object edOkonh: TEdit [18]
    Left = 136
    Top = 112
    Width = 79
    Height = 21
    MaxLength = 30
    TabOrder = 5
    OnChange = edInnChange
    OnKeyPress = edInnKeyPress
  end
  object edOkpo: TEdit [19]
    Left = 263
    Top = 112
    Width = 82
    Height = 21
    MaxLength = 30
    TabOrder = 6
    OnChange = edInnChange
    OnKeyPress = edInnKeyPress
  end
  object edPostAddress: TEdit [20]
    Left = 136
    Top = 164
    Width = 305
    Height = 21
    MaxLength = 100
    TabOrder = 8
    OnChange = edInnChange
  end
  object edBank: TEdit [21]
    Left = 136
    Top = 190
    Width = 189
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 9
    OnChange = edInnChange
    OnKeyDown = edBankKeyDown
  end
  object bibBank: TBitBtn [22]
    Left = 325
    Top = 190
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 10
    OnClick = bibBankClick
  end
  object edContactPeople: TEdit [23]
    Left = 135
    Top = 216
    Width = 306
    Height = 21
    MaxLength = 30
    TabOrder = 11
    OnChange = edInnChange
  end
  object edPhone: TEdit [24]
    Left = 135
    Top = 241
    Width = 306
    Height = 21
    MaxLength = 30
    TabOrder = 12
    OnChange = edInnChange
  end
  object bibAddAccount: TBitBtn [25]
    Left = 269
    Top = 35
    Width = 172
    Height = 21
    Hint = 'Дополнительные расчетные счета'
    Caption = 'Дополнительные р/счета'
    TabOrder = 2
    OnClick = bibAddAccountClick
  end
  inherited IBTran: TIBTransaction
    Left = 128
    Top = 281
  end
end
