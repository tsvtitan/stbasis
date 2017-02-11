inherited fmEditRBEmpPlant: TfmEditRBEmpPlant
  Left = 237
  Top = 76
  Caption = 'fmEditRBEmpPlant'
  ClientHeight = 447
  ClientWidth = 333
  PixelsPerInch = 96
  TextHeight = 13
  object lbCategory: TLabel [0]
    Left = 69
    Top = 116
    Width = 56
    Height = 13
    Caption = 'Категория:'
  end
  object lbDateStart: TLabel [1]
    Left = 73
    Top = 272
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
    Top = 38
    Width = 33
    Height = 13
    Caption = 'Сетка:'
  end
  object lbClass: TLabel [4]
    Left = 85
    Top = 63
    Width = 40
    Height = 13
    Caption = 'Разряд:'
  end
  object lbReasonDocum: TLabel [5]
    Left = 6
    Top = 89
    Width = 119
    Height = 13
    Caption = 'На основании приказа:'
  end
  object lbSeat: TLabel [6]
    Left = 64
    Top = 142
    Width = 61
    Height = 13
    Caption = 'Должность:'
  end
  object lbDepart: TLabel [7]
    Left = 91
    Top = 168
    Width = 34
    Height = 13
    Caption = 'Отдел:'
  end
  object lbOrderDocum: TLabel [8]
    Left = 25
    Top = 194
    Width = 100
    Height = 13
    Caption = 'Приказ о принятии:'
  end
  object lbProf: TLabel [9]
    Left = 64
    Top = 220
    Width = 61
    Height = 13
    Caption = 'Профессия:'
  end
  object lbschedule: TLabel [10]
    Left = 84
    Top = 246
    Width = 41
    Height = 13
    Caption = 'График:'
  end
  inherited pnBut: TPanel
    Top = 409
    Width = 333
    TabOrder = 23
    inherited Panel2: TPanel
      Left = 148
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 395
    TabOrder = 22
  end
  object dtpDateStart: TDateTimePicker [13]
    Left = 229
    Top = 268
    Width = 94
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 20
    OnChange = edPlantChange
  end
  object edPlant: TEdit [14]
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
  object bibPlant: TBitBtn [15]
    Left = 302
    Top = 10
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPlantClick
  end
  object edNet: TEdit [16]
    Left = 133
    Top = 35
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edPlantChange
  end
  object bibNet: TBitBtn [17]
    Left = 302
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibNetClick
  end
  object edClass: TEdit [18]
    Left = 133
    Top = 60
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edPlantChange
  end
  object bibClass: TBitBtn [19]
    Left = 302
    Top = 60
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibClassClick
  end
  object edReasonDocum: TEdit [20]
    Left = 133
    Top = 86
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnChange = edPlantChange
  end
  object bibReasonDocum: TBitBtn [21]
    Left = 302
    Top = 86
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibReasonDocumClick
  end
  object edCategory: TEdit [22]
    Left = 133
    Top = 112
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 8
    OnChange = edPlantChange
  end
  object bibCategory: TBitBtn [23]
    Left = 302
    Top = 112
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 9
    OnClick = bibCategoryClick
  end
  object edSeat: TEdit [24]
    Left = 133
    Top = 138
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 10
    OnChange = edPlantChange
  end
  object bibSeat: TBitBtn [25]
    Left = 302
    Top = 138
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 11
    OnClick = bibSeatClick
  end
  object edDepart: TEdit [26]
    Left = 133
    Top = 164
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 12
    OnChange = edPlantChange
  end
  object bibDepart: TBitBtn [27]
    Left = 302
    Top = 164
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 13
    OnClick = bibDepartClick
  end
  object edOrderDocum: TEdit [28]
    Left = 133
    Top = 190
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 14
    OnChange = edPlantChange
  end
  object bibOrderDocum: TBitBtn [29]
    Left = 302
    Top = 190
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 15
    OnClick = bibOrderDocumClick
  end
  object edProf: TEdit [30]
    Left = 133
    Top = 216
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 16
    OnChange = edPlantChange
  end
  object bibProf: TBitBtn [31]
    Left = 302
    Top = 216
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 17
    OnClick = bibProfClick
  end
  object grbRemove: TGroupBox [32]
    Left = 7
    Top = 291
    Width = 316
    Height = 103
    Caption = 'Информация об увольнении'
    TabOrder = 21
    object lbReleaseDate: TLabel
      Left = 18
      Top = 22
      Width = 91
      Height = 13
      Caption = 'Дата увольнения:'
    end
    object lbMotive: TLabel
      Left = 63
      Top = 49
      Width = 46
      Height = 13
      Caption = 'Причина:'
    end
    object lbMotiveDocum: TLabel
      Left = 68
      Top = 75
      Width = 41
      Height = 13
      Caption = 'Приказ:'
    end
    object dtpReleaseDate: TDateTimePicker
      Left = 117
      Top = 19
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
      Top = 45
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 1
      OnChange = edPlantChange
      OnKeyDown = edMotiveKeyDown
    end
    object bibMotive: TBitBtn
      Left = 286
      Top = 45
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 2
      OnClick = bibMotiveClick
    end
    object edMotiveDocum: TEdit
      Left = 117
      Top = 71
      Width = 169
      Height = 21
      Color = clBtnFace
      MaxLength = 100
      ReadOnly = True
      TabOrder = 3
      OnChange = edPlantChange
      OnKeyDown = edMotiveDocumKeyDown
    end
    object bibMotiveDocum: TBitBtn
      Left = 286
      Top = 71
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 4
      OnClick = bibMotiveDocumClick
    end
  end
  object edschedule: TEdit [33]
    Left = 133
    Top = 242
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 18
    OnChange = edPlantChange
  end
  object bibschedule: TBitBtn [34]
    Left = 302
    Top = 242
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 19
    OnClick = bibscheduleClick
  end
  inherited IBTran: TIBTransaction
    Left = 144
    Top = 417
  end
end
