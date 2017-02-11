inherited fmEditRBEmpStreet: TfmEditRBEmpStreet
  Left = 417
  Top = 225
  Caption = 'fmEditRBEmpStreet'
  ClientHeight = 326
  ClientWidth = 304
  PixelsPerInch = 96
  TextHeight = 13
  object lbhousenum: TLabel [0]
    Left = 31
    Top = 174
    Width = 66
    Height = 13
    Caption = 'Номер дома:'
  end
  object lbbuildnum: TLabel [1]
    Left = 16
    Top = 200
    Width = 81
    Height = 13
    Caption = 'Номер корпуса:'
  end
  object lbflatnum: TLabel [2]
    Left = 8
    Top = 226
    Width = 89
    Height = 13
    Caption = 'Номер квартиры:'
  end
  object lbStreet: TLabel [3]
    Left = 62
    Top = 147
    Width = 35
    Height = 13
    Caption = 'Улица:'
  end
  object lbTypeLive: TLabel [4]
    Left = 10
    Top = 251
    Width = 87
    Height = 13
    Caption = 'Тип проживания:'
  end
  object lbCountry: TLabel [5]
    Left = 58
    Top = 12
    Width = 39
    Height = 13
    Caption = 'Страна:'
  end
  object lbregion: TLabel [6]
    Left = 22
    Top = 39
    Width = 75
    Height = 13
    Caption = 'Край, область:'
  end
  object lbstate: TLabel [7]
    Left = 63
    Top = 66
    Width = 34
    Height = 13
    Caption = 'Район:'
  end
  object lbTown: TLabel [8]
    Left = 64
    Top = 93
    Width = 33
    Height = 13
    Caption = 'Город:'
  end
  object lbplacement: TLabel [9]
    Left = 40
    Top = 120
    Width = 57
    Height = 13
    Caption = 'Нас. пункт:'
  end
  inherited pnBut: TPanel
    Top = 288
    Width = 304
    TabOrder = 18
    inherited Panel2: TPanel
      Left = 119
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 273
    TabOrder = 17
  end
  object edhousenum: TEdit [12]
    Left = 104
    Top = 170
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 12
    OnChange = edStreetChange
  end
  object edbuildnum: TEdit [13]
    Left = 104
    Top = 196
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 13
    OnChange = edStreetChange
  end
  object edflatnum: TEdit [14]
    Left = 104
    Top = 222
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 14
    OnChange = edStreetChange
  end
  object edStreet: TEdit [15]
    Left = 104
    Top = 144
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 10
    OnChange = edStreetChange
    OnKeyDown = edStreetKeyDown
  end
  object bibStreet: TBitBtn [16]
    Left = 273
    Top = 144
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 11
    OnClick = bibStreetClick
  end
  object edTypeLive: TEdit [17]
    Left = 104
    Top = 248
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 15
    OnChange = edStreetChange
  end
  object bibTypeLive: TBitBtn [18]
    Left = 273
    Top = 248
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 16
    OnClick = bibTypeLiveClick
  end
  object edCountry: TEdit [19]
    Left = 104
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edStreetChange
  end
  object bibCountry: TBitBtn [20]
    Left = 273
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibCountryClick
  end
  object edregion: TEdit [21]
    Left = 104
    Top = 36
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edStreetChange
    OnKeyDown = edregionKeyDown
  end
  object bibregion: TBitBtn [22]
    Left = 273
    Top = 36
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibregionClick
  end
  object edstate: TEdit [23]
    Left = 104
    Top = 63
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edStreetChange
    OnKeyDown = edstateKeyDown
  end
  object bibstate: TBitBtn [24]
    Left = 273
    Top = 63
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibstateClick
  end
  object edtown: TEdit [25]
    Left = 104
    Top = 90
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnChange = edStreetChange
    OnKeyDown = edtownKeyDown
  end
  object bibtown: TBitBtn [26]
    Left = 273
    Top = 90
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibtownClick
  end
  object edplacement: TEdit [27]
    Left = 104
    Top = 117
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 8
    OnChange = edStreetChange
    OnKeyDown = edplacementKeyDown
  end
  object bibplacement: TBitBtn [28]
    Left = 273
    Top = 117
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 9
    OnClick = bibplacementClick
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 65
  end
end
