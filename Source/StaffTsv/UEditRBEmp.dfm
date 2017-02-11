inherited fmEditRBEmp: TfmEditRBEmp
  Left = 447
  Top = 136
  Caption = 'fmEditRBEmp'
  ClientHeight = 470
  ClientWidth = 327
  PixelsPerInch = 96
  TextHeight = 13
  object lbTabNum: TLabel [0]
    Left = 8
    Top = 12
    Width = 95
    Height = 13
    Caption = 'Табельный номер:'
  end
  object lbContinioussenioritydate: TLabel [1]
    Left = 124
    Top = 400
    Width = 103
    Height = 13
    Caption = 'Непрерывный стаж:'
  end
  object lbFName: TLabel [2]
    Left = 51
    Top = 36
    Width = 52
    Height = 13
    Caption = 'Фамилия:'
  end
  object lbName: TLabel [3]
    Left = 78
    Top = 60
    Width = 25
    Height = 13
    Caption = 'Имя:'
  end
  object lbSName: TLabel [4]
    Left = 53
    Top = 84
    Width = 50
    Height = 13
    Caption = 'Отчество:'
  end
  object lbSex: TLabel [5]
    Left = 108
    Top = 108
    Width = 23
    Height = 13
    Caption = 'Пол:'
  end
  object lbBirthDate: TLabel [6]
    Left = 49
    Top = 132
    Width = 82
    Height = 13
    Caption = 'Дата рождения:'
  end
  object lbPerscardnum: TLabel [7]
    Left = 7
    Top = 156
    Width = 124
    Height = 13
    Caption = 'Номер личной карточки:'
  end
  object lbFamilyStateName: TLabel [8]
    Left = 18
    Top = 203
    Width = 113
    Height = 13
    Caption = 'Семейное положение:'
  end
  object lbNationname: TLabel [9]
    Left = 43
    Top = 227
    Width = 88
    Height = 13
    Caption = 'Национальность:'
  end
  object lbInn: TLabel [10]
    Left = 104
    Top = 180
    Width = 27
    Height = 13
    Caption = 'ИНН:'
  end
  object lbRelease: TLabel [11]
    Left = 131
    Top = 400
    Width = 37
    Height = 13
    Caption = 'Статус:'
    Visible = False
  end
  inherited pnBut: TPanel
    Top = 432
    Width = 327
    TabOrder = 18
    inherited Panel2: TPanel
      Left = 142
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 416
    TabOrder = 17
  end
  object edTabNum: TEdit [14]
    Left = 110
    Top = 8
    Width = 76
    Height = 21
    MaxLength = 9
    TabOrder = 0
    OnChange = edTabNumChange
    OnKeyPress = edTabNumKeyPress
  end
  object bibTabNumNext: TBitBtn [15]
    Left = 185
    Top = 8
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '<-'
    TabOrder = 1
    OnClick = bibTabNumNextClick
  end
  object dtpContinioussenioritydate: TDateTimePicker [16]
    Left = 237
    Top = 396
    Width = 81
    Height = 21
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = True
    TabOrder = 15
    OnChange = edTabNumChange
  end
  object edFname: TEdit [17]
    Left = 110
    Top = 32
    Width = 208
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edTabNumChange
  end
  object edName: TEdit [18]
    Left = 110
    Top = 56
    Width = 208
    Height = 21
    MaxLength = 30
    TabOrder = 3
    OnChange = edTabNumChange
  end
  object edSname: TEdit [19]
    Left = 110
    Top = 80
    Width = 208
    Height = 21
    MaxLength = 30
    TabOrder = 4
    OnChange = edTabNumChange
  end
  object dtpBirthDate: TDateTimePicker [20]
    Left = 138
    Top = 128
    Width = 81
    Height = 21
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = True
    TabOrder = 7
    OnChange = edTabNumChange
  end
  object edPerscardnum: TEdit [21]
    Left = 138
    Top = 152
    Width = 180
    Height = 21
    MaxLength = 30
    TabOrder = 8
    OnChange = edTabNumChange
  end
  object edFamilyStateName: TEdit [22]
    Left = 138
    Top = 200
    Width = 159
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 10
    OnChange = edTabNumChange
  end
  object bibFamilyStateName: TBitBtn [23]
    Left = 297
    Top = 200
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 11
    OnClick = bibFamilyStateNameClick
  end
  object edNationname: TEdit [24]
    Left = 138
    Top = 224
    Width = 159
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 12
    OnChange = edTabNumChange
  end
  object bibNationname: TBitBtn [25]
    Left = 297
    Top = 224
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 13
    OnClick = bibNationnameClick
  end
  object edSex: TEdit [26]
    Left = 138
    Top = 104
    Width = 159
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 5
    OnChange = edTabNumChange
  end
  object bibSex: TBitBtn [27]
    Left = 297
    Top = 104
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 6
    OnClick = bibSexClick
  end
  object edInn: TEdit [28]
    Left = 138
    Top = 176
    Width = 180
    Height = 21
    MaxLength = 30
    TabOrder = 9
    OnChange = edTabNumChange
    OnKeyPress = edTabNumKeyPress
  end
  object grbBorn: TGroupBox [29]
    Left = 7
    Top = 248
    Width = 312
    Height = 142
    Caption = ' Место рождения '
    TabOrder = 14
    object lbCountry: TLabel
      Left = 67
      Top = 19
      Width = 39
      Height = 13
      Caption = 'Страна:'
    end
    object lbregion: TLabel
      Left = 31
      Top = 43
      Width = 75
      Height = 13
      Caption = 'Край, область:'
    end
    object lbstate: TLabel
      Left = 72
      Top = 67
      Width = 34
      Height = 13
      Caption = 'Район:'
    end
    object lbTown: TLabel
      Left = 73
      Top = 91
      Width = 33
      Height = 13
      Caption = 'Город:'
    end
    object lbplacement: TLabel
      Left = 49
      Top = 116
      Width = 57
      Height = 13
      Caption = 'Нас. пункт:'
    end
    object edCountry: TEdit
      Left = 113
      Top = 16
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 0
    end
    object bibCountry: TBitBtn
      Left = 282
      Top = 16
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 1
      OnClick = bibCountryClick
    end
    object edregion: TEdit
      Left = 113
      Top = 40
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 2
      OnKeyDown = edregionKeyDown
    end
    object bibregion: TBitBtn
      Left = 282
      Top = 40
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 3
      OnClick = bibregionClick
    end
    object edstate: TEdit
      Left = 113
      Top = 64
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 4
      OnKeyDown = edstateKeyDown
    end
    object bibstate: TBitBtn
      Left = 282
      Top = 64
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 5
      OnClick = bibstateClick
    end
    object edtown: TEdit
      Left = 113
      Top = 88
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 6
      OnKeyDown = edtownKeyDown
    end
    object bibtown: TBitBtn
      Left = 282
      Top = 88
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 7
      OnClick = bibtownClick
    end
    object edplacement: TEdit
      Left = 113
      Top = 112
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 8
      OnKeyDown = edplacementKeyDown
    end
    object bibplacement: TBitBtn
      Left = 282
      Top = 112
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 9
      OnClick = bibplacementClick
    end
  end
  object cmbRelease: TComboBox [30]
    Left = 176
    Top = 396
    Width = 142
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 16
    Visible = False
    Items.Strings = (
      ''
      'Работающие'
      'Уволенные')
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 46
  end
end
