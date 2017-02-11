inherited fmEditRBEmpPlant: TfmEditRBEmpPlant
  Left = 241
  Top = 30
  Caption = 'fmEditRBEmpPlant'
  ClientHeight = 477
  ClientWidth = 333
  PixelsPerInch = 96
  TextHeight = 13
  object lbCategory: TLabel [0]
    Left = 69
    Top = 86
    Width = 56
    Height = 13
    Caption = 'Категория:'
  end
  object lbDateStart: TLabel [1]
    Left = 73
    Top = 309
    Width = 148
    Height = 13
    Caption = 'Дата поступления на работу:'
  end
  object lbPlant: TLabel [2]
    Left = 55
    Top = 13
    Width = 70
    Height = 13
    Caption = 'Где работает:'
  end
  object lbNet: TLabel [3]
    Left = 92
    Top = 62
    Width = 33
    Height = 13
    Caption = 'Сетка:'
  end
  object lbReasonDocum: TLabel [4]
    Left = 6
    Top = 37
    Width = 119
    Height = 13
    Caption = 'На основании приказа:'
  end
  object lbOrderDocum: TLabel [5]
    Left = 25
    Top = 237
    Width = 100
    Height = 13
    Caption = 'Приказ о принятии:'
  end
  object lbProf: TLabel [6]
    Left = 64
    Top = 261
    Width = 61
    Height = 13
    Caption = 'Профессия:'
  end
  object lbschedule: TLabel [7]
    Left = 84
    Top = 285
    Width = 41
    Height = 13
    Caption = 'График:'
  end
  inherited pnBut: TPanel
    Top = 439
    Width = 333
    TabOrder = 18
    inherited Panel2: TPanel
      Left = 148
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 424
    TabOrder = 17
  end
  object dtpDateStart: TDateTimePicker [10]
    Left = 229
    Top = 305
    Width = 94
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 15
    OnChange = edPlantChange
  end
  object edPlant: TEdit [11]
    Left = 133
    Top = 10
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edPlantChange
  end
  object bibPlant: TBitBtn [12]
    Left = 302
    Top = 10
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPlantClick
  end
  object edNet: TEdit [13]
    Left = 133
    Top = 58
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edPlantChange
  end
  object bibNet: TBitBtn [14]
    Left = 302
    Top = 58
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibNetClick
  end
  object edReasonDocum: TEdit [15]
    Left = 133
    Top = 34
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edPlantChange
  end
  object bibReasonDocum: TBitBtn [16]
    Left = 302
    Top = 34
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibReasonDocumClick
  end
  object edCategory: TEdit [17]
    Left = 133
    Top = 82
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnChange = edPlantChange
  end
  object bibCategory: TBitBtn [18]
    Left = 302
    Top = 82
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibCategoryClick
  end
  object edOrderDocum: TEdit [19]
    Left = 133
    Top = 233
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 9
    OnChange = edPlantChange
  end
  object bibOrderDocum: TBitBtn [20]
    Left = 302
    Top = 233
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 10
    OnClick = bibOrderDocumClick
  end
  object edProf: TEdit [21]
    Left = 133
    Top = 257
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 11
    OnChange = edPlantChange
  end
  object bibProf: TBitBtn [22]
    Left = 302
    Top = 257
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 12
    OnClick = bibProfClick
  end
  object grbRemove: TGroupBox [23]
    Left = 7
    Top = 327
    Width = 316
    Height = 95
    Caption = 'Информация об увольнении'
    TabOrder = 16
    object lbReleaseDate: TLabel
      Left = 18
      Top = 21
      Width = 91
      Height = 13
      Caption = 'Дата увольнения:'
    end
    object lbMotive: TLabel
      Left = 63
      Top = 47
      Width = 46
      Height = 13
      Caption = 'Причина:'
      Enabled = False
    end
    object lbMotiveDocum: TLabel
      Left = 68
      Top = 71
      Width = 41
      Height = 13
      Caption = 'Приказ:'
      Enabled = False
    end
    object dtpReleaseDate: TDateTimePicker
      Left = 117
      Top = 18
      Width = 95
      Height = 22
      CalAlignment = dtaLeft
      Date = 37156
      Time = 37156
      ShowCheckbox = True
      Checked = False
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
      OnChange = edPlantChange
    end
    object edMotive: TEdit
      Left = 117
      Top = 43
      Width = 169
      Height = 21
      Color = clBtnFace
      Enabled = False
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
      OnChange = edPlantChange
      OnKeyDown = edMotiveKeyDown
    end
    object bibMotive: TBitBtn
      Left = 286
      Top = 43
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      Enabled = False
      TabOrder = 2
      OnClick = bibMotiveClick
    end
    object edMotiveDocum: TEdit
      Left = 117
      Top = 67
      Width = 169
      Height = 21
      Color = clBtnFace
      Enabled = False
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
      OnChange = edPlantChange
      OnKeyDown = edMotiveDocumKeyDown
    end
    object bibMotiveDocum: TBitBtn
      Left = 286
      Top = 67
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      Enabled = False
      TabOrder = 4
      OnClick = bibMotiveDocumClick
    end
  end
  object edschedule: TEdit [24]
    Left = 133
    Top = 281
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 13
    OnChange = edPlantChange
  end
  object bibschedule: TBitBtn [25]
    Left = 302
    Top = 281
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 14
    OnClick = bibscheduleClick
  end
  object grbForSeatClass: TGroupBox [26]
    Left = 7
    Top = 105
    Width = 316
    Height = 121
    Caption = ' По штатному расписанию '
    TabOrder = 8
    object lbDepart: TLabel
      Left = 75
      Top = 22
      Width = 34
      Height = 13
      Caption = 'Отдел:'
    end
    object lbSeat: TLabel
      Left = 48
      Top = 47
      Width = 61
      Height = 13
      Caption = 'Должность:'
    end
    object lbClass: TLabel
      Left = 69
      Top = 70
      Width = 40
      Height = 13
      Caption = 'Разряд:'
    end
    object lbPay: TLabel
      Left = 166
      Top = 95
      Width = 35
      Height = 13
      Caption = 'Оклад:'
    end
    object edDepart: TEdit
      Left = 117
      Top = 19
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
      OnChange = edPlantChange
    end
    object bibDepart: TBitBtn
      Left = 286
      Top = 19
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 2
      OnClick = bibDepartClick
    end
    object edSeat: TEdit
      Left = 117
      Top = 43
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
      OnChange = edPlantChange
    end
    object bibSeat: TBitBtn
      Left = 286
      Top = 43
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 4
      OnClick = bibSeatClick
    end
    object edClass: TEdit
      Left = 117
      Top = 67
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 5
      OnChange = edPlantChange
    end
    object bibClass: TBitBtn
      Left = 286
      Top = 67
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 6
      OnClick = bibClassClick
    end
    object bibFromSeatClass: TBitBtn
      Left = 10
      Top = 17
      Width = 31
      Height = 94
      Hint = 'Взять из штатного расписания'
      Caption = '---->'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = bibFromSeatClassClick
    end
    object edPay: TEdit
      Left = 208
      Top = 91
      Width = 99
      Height = 21
      MaxLength = 100
      TabOrder = 7
      Text = '0'
      OnChange = edPayChange
      OnKeyPress = edPayKeyPress
    end
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 262
  end
end
