inherited fmEditRBCharge: TfmEditRBCharge
  Left = 259
  Top = 132
  Caption = 'fmEditRBCharge'
  ClientHeight = 336
  ClientWidth = 317
  PixelsPerInch = 96
  TextHeight = 13
  object lbfixedamount: TLabel [0]
    Left = 135
    Top = 211
    Width = 71
    Height = 13
    Caption = 'Фикс. сумма:'
  end
  object lbstandartoperation: TLabel [1]
    Left = 50
    Top = 61
    Width = 53
    Height = 13
    Caption = 'Операция:'
  end
  object lbName: TLabel [2]
    Left = 24
    Top = 11
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbShortName: TLabel [3]
    Left = 58
    Top = 36
    Width = 45
    Height = 13
    Caption = 'Краткое:'
  end
  object lbchargegroup: TLabel [4]
    Left = 65
    Top = 87
    Width = 38
    Height = 13
    Caption = 'Группа:'
  end
  object lbroundtype: TLabel [5]
    Left = 20
    Top = 113
    Width = 83
    Height = 13
    Caption = 'Вид округления:'
  end
  object lbalgorithm: TLabel [6]
    Left = 51
    Top = 139
    Width = 52
    Height = 13
    Caption = 'Алгоритм:'
  end
  object lbfixedrateathours: TLabel [7]
    Left = 96
    Top = 236
    Width = 110
    Height = 13
    Caption = 'Фикс. норма в часах:'
  end
  object lbfixedpercent: TLabel [8]
    Left = 127
    Top = 261
    Width = 79
    Height = 13
    Caption = 'Фикс. процент:'
  end
  object lbFlag: TLabel [9]
    Left = 16
    Top = 158
    Width = 85
    Height = 26
    Alignment = taRightJustify
    Caption = 'Начисление или удержание:'
    Visible = False
    WordWrap = True
  end
  inherited pnBut: TPanel
    Top = 298
    Width = 317
    TabOrder = 17
    inherited Panel2: TPanel
      Left = 132
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 282
    TabOrder = 16
  end
  object edfixedamount: TEdit [12]
    Left = 212
    Top = 207
    Width = 93
    Height = 21
    MaxLength = 100
    TabOrder = 13
    OnChange = edNameChange
    OnKeyPress = edfixedamountKeyPress
  end
  object edstandartoperation: TEdit [13]
    Left = 109
    Top = 57
    Width = 175
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edNameChange
  end
  object bibstandartoperation: TBitBtn [14]
    Left = 284
    Top = 57
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibstandartoperationClick
  end
  object edName: TEdit [15]
    Left = 109
    Top = 7
    Width = 196
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edShortName: TEdit [16]
    Left = 109
    Top = 32
    Width = 196
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edNameChange
  end
  object edchargegroup: TEdit [17]
    Left = 109
    Top = 83
    Width = 175
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edNameChange
  end
  object bibchargegroup: TBitBtn [18]
    Left = 284
    Top = 83
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibchargegroupClick
  end
  object edroundtype: TEdit [19]
    Left = 109
    Top = 109
    Width = 175
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnChange = edNameChange
  end
  object bibroundtype: TBitBtn [20]
    Left = 284
    Top = 109
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibroundtypeClick
  end
  object edalgorithm: TEdit [21]
    Left = 109
    Top = 135
    Width = 175
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 8
    OnChange = edNameChange
  end
  object bibalgorithm: TBitBtn [22]
    Left = 284
    Top = 135
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 9
    OnClick = bibalgorithmClick
  end
  object chbflag: TCheckBox [23]
    Left = 109
    Top = 164
    Width = 97
    Height = 17
    Caption = 'Это удержание'
    TabOrder = 11
    OnClick = chbflagClick
  end
  object chbfallsintototal: TCheckBox [24]
    Left = 109
    Top = 187
    Width = 97
    Height = 17
    Caption = 'Входит в итого'
    TabOrder = 12
    OnClick = chbflagClick
  end
  object edfixedrateathours: TEdit [25]
    Left = 212
    Top = 232
    Width = 93
    Height = 21
    MaxLength = 100
    TabOrder = 14
    OnChange = edNameChange
    OnKeyPress = edfixedamountKeyPress
  end
  object edfixedpercent: TEdit [26]
    Left = 212
    Top = 257
    Width = 93
    Height = 21
    MaxLength = 100
    TabOrder = 15
    OnChange = edNameChange
    OnKeyPress = edfixedamountKeyPress
  end
  object cmbFlag: TComboBox [27]
    Left = 109
    Top = 162
    Width = 104
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 10
    Visible = False
    Items.Strings = (
      ''
      'Начисление'
      'Удержание')
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 217
  end
end
