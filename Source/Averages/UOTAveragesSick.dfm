object fmOTAveragesSick: TfmOTAveragesSick
  Left = 352
  Top = 164
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Листки нетрудоспособности'
  ClientHeight = 438
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 53
    Height = 13
    Caption = 'Сотрудник'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 72
    Height = 13
    Caption = 'Место работы'
  end
  object Label3: TLabel
    Left = 376
    Top = 72
    Width = 83
    Height = 13
    Caption = 'Процент оплаты'
  end
  object Label5: TLabel
    Left = 8
    Top = 384
    Width = 79
    Height = 13
    Caption = 'Сумма пособия'
  end
  object Label6: TLabel
    Left = 8
    Top = 248
    Width = 95
    Height = 13
    Caption = 'Результат расчёта'
  end
  object Label7: TLabel
    Left = 8
    Top = 408
    Width = 84
    Height = 13
    Caption = 'Сумма среднего'
  end
  object bibEmp: TBitBtn
    Left = 312
    Top = 8
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibEmpClick
  end
  object edEmp: TEdit
    Left = 72
    Top = 8
    Width = 233
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
  end
  object grbBirthDate: TGroupBox
    Left = 344
    Top = 8
    Width = 281
    Height = 47
    Caption = 'Период'
    TabOrder = 3
    object lbBirthDateFrom: TLabel
      Left = 8
      Top = 20
      Width = 9
      Height = 13
      Caption = 'с:'
    end
    object lbBirthDateTo: TLabel
      Left = 128
      Top = 20
      Width = 15
      Height = 13
      Caption = 'по:'
    end
    object dtpBirthDateFrom: TDateTimePicker
      Left = 24
      Top = 16
      Width = 97
      Height = 22
      CalAlignment = dtaLeft
      Date = 37147
      Time = 37147
      ShowCheckbox = True
      Checked = False
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
    end
    object dtpBirthDateTo: TDateTimePicker
      Left = 152
      Top = 16
      Width = 97
      Height = 22
      CalAlignment = dtaLeft
      Date = 37147
      Time = 37147
      ShowCheckbox = True
      Checked = False
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 1
    end
    object bibBirthDate: TBitBtn
      Left = 253
      Top = 17
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 2
      OnClick = bibBirthDateClick
    end
  end
  object Button1: TButton
    Left = 424
    Top = 408
    Width = 123
    Height = 25
    Caption = 'Выполнить расчёт'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    OnClick = Button1Click
  end
  object cbEmpPlants: TComboBox
    Left = 88
    Top = 40
    Width = 249
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object EditPercent: TRxSpinEdit
    Left = 472
    Top = 72
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 100
    MinValue = 1
    Value = 100
    TabOrder = 5
  end
  object CheckBox1: TCheckBox
    Left = 376
    Top = 96
    Width = 97
    Height = 17
    Caption = 'Без оплаты'
    TabOrder = 6
  end
  object CurrencyEdit1: TCurrencyEdit
    Left = 104
    Top = 384
    Width = 121
    Height = 21
    AutoSize = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 11
  end
  object RadioGroup1: TRadioGroup
    Left = 120
    Top = 64
    Width = 217
    Height = 57
    Items.Strings = (
      'Простой смертный'
      'Одинокие, вдовы и т.д.'
      'Ребёнок до 3-х, инвалид до 16-ти')
    TabOrder = 7
  end
  object RadioGroup2: TRadioGroup
    Left = 8
    Top = 64
    Width = 105
    Height = 57
    Hint = 'Выберите необходимый тип расчёта'
    Caption = 'Тип расчёта'
    Items.Strings = (
      'По дням'
      'По часам')
    TabOrder = 4
  end
  object RxDBGrid1: TRxDBGrid
    Left = 8
    Top = 264
    Width = 617
    Height = 113
    Color = clBtnFace
    DataSource = dsData
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 10
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Button2: TButton
    Left = 552
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Закрыть'
    TabOrder = 14
    OnClick = Button2Click
  end
  object CurrencyEdit2: TCurrencyEdit
    Left = 104
    Top = 408
    Width = 121
    Height = 21
    AutoSize = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 12
  end
  object GroupBox1: TGroupBox
    Left = 304
    Top = 128
    Width = 321
    Height = 113
    Caption = 'Информация по расчётным месяцам'
    TabOrder = 9
    object LabelM1: TLabel
      Left = 8
      Top = 16
      Width = 71
      Height = 13
      Caption = '<Нет данных>'
    end
    object Label9: TLabel
      Left = 8
      Top = 32
      Width = 43
      Height = 13
      Caption = 'Отр. дни'
    end
    object Label10: TLabel
      Left = 8
      Top = 56
      Width = 50
      Height = 13
      Caption = 'Отр. часы'
    end
    object Label11: TLabel
      Left = 8
      Top = 80
      Width = 54
      Height = 13
      Caption = 'Зар. плата'
    end
    object Bevel1: TBevel
      Left = 160
      Top = 16
      Width = 9
      Height = 89
      Shape = bsLeftLine
    end
    object LabelM2: TLabel
      Left = 168
      Top = 16
      Width = 71
      Height = 13
      Caption = '<Нет данных>'
    end
    object Label12: TLabel
      Left = 168
      Top = 32
      Width = 43
      Height = 13
      Caption = 'Отр. дни'
    end
    object Label13: TLabel
      Left = 168
      Top = 56
      Width = 50
      Height = 13
      Caption = 'Отр. часы'
    end
    object Label14: TLabel
      Left = 168
      Top = 80
      Width = 54
      Height = 13
      Caption = 'Зар. плата'
    end
    object EditM1D: TEdit
      Left = 72
      Top = 32
      Width = 81
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object EditM1H: TEdit
      Left = 72
      Top = 56
      Width = 81
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object EditM2D: TEdit
      Left = 232
      Top = 32
      Width = 81
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
    object EditM2H: TEdit
      Left = 232
      Top = 56
      Width = 81
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
    end
    object EditM1P: TCurrencyEdit
      Left = 72
      Top = 80
      Width = 81
      Height = 21
      AutoSize = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object EditM2P: TCurrencyEdit
      Left = 232
      Top = 80
      Width = 81
      Height = 21
      AutoSize = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
    end
  end
  object RadioGroup3: TRadioGroup
    Left = 8
    Top = 128
    Width = 289
    Height = 113
    Caption = 'Вид расчёта'
    Items.Strings = (
      'Расчёт пособия по общему заболеванию'
      'Расчёт пособия по уходу за больным'
      'Расчёт пособия при бытовой травме'
      'Расчёт пособия по беременности и родам'
      'Расчёт пособия при рождении ребёнка'
      'Расчёт пособия  по проф. заболеванию')
    TabOrder = 8
  end
  object quEmpPlant: TIBQuery
    Transaction = trRead
    BufferChunks = 1000
    CachedUpdates = False
    Left = 128
    Top = 65528
  end
  object trRead: TIBTransaction
    Active = False
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 208
    Top = 65528
  end
  object memData: TRxMemoryData
    Active = True
    FieldDefs = <
      item
        Name = 'FDate'
        DataType = ftDate
      end
      item
        Name = 'SickDaysCount'
        DataType = ftInteger
      end
      item
        Name = 'SickHoursCount'
        DataType = ftFloat
      end
      item
        Name = 'NormalDaysCount'
        DataType = ftInteger
      end
      item
        Name = 'NormalHoursCount'
        DataType = ftFloat
      end
      item
        Name = 'CalendarDays'
        DataType = ftInteger
      end
      item
        Name = 'withoutPay'
        DataType = ftBoolean
      end
      item
        Name = 'PayPercent'
        DataType = ftInteger
      end
      item
        Name = 'OnePay'
        DataType = ftCurrency
      end>
    Left = 208
    Top = 304
    object memDataFDate: TDateField
      DisplayLabel = 'Дата'
      FieldName = 'FDate'
    end
    object memDataSickDaysCount: TIntegerField
      DisplayLabel = 'Дни болезни'
      FieldName = 'SickDaysCount'
    end
    object memDataSickHoursCount: TFloatField
      DisplayLabel = 'Часы болезни'
      FieldName = 'SickHoursCount'
    end
    object memDataNormalDaysCount: TIntegerField
      DisplayLabel = 'Норма дней'
      FieldName = 'NormalDaysCount'
    end
    object memDataNormalHoursCount: TFloatField
      DisplayLabel = 'Норма часов'
      FieldName = 'NormalHoursCount'
    end
    object memDataCalendarDays: TIntegerField
      DisplayLabel = 'Календарные дни'
      FieldName = 'CalendarDays'
    end
    object memDatawithoutPay: TBooleanField
      DisplayLabel = 'Без оплаты'
      FieldName = 'withoutPay'
    end
    object memDataPayPercent: TIntegerField
      DisplayLabel = 'Процент'
      FieldName = 'PayPercent'
    end
    object memDataOnePay: TCurrencyField
      DisplayLabel = 'Сумма'
      FieldName = 'OnePay'
    end
  end
  object dsData: TDataSource
    DataSet = memData
    Left = 280
    Top = 328
  end
end
