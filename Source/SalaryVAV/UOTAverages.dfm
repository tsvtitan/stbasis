object fmOTAverages: TfmOTAverages
  Left = 348
  Top = 181
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Листки нетрудоспособности'
  ClientHeight = 373
  ClientWidth = 583
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
    Left = 120
    Top = 128
    Width = 83
    Height = 13
    Caption = 'Процент оплаты'
  end
  object Label4: TLabel
    Left = 344
    Top = 8
    Width = 62
    Height = 13
    Caption = 'Вид расчёта'
  end
  object Label5: TLabel
    Left = 8
    Top = 320
    Width = 79
    Height = 13
    Caption = 'Сумма пособия'
  end
  object Label6: TLabel
    Left = 8
    Top = 184
    Width = 96
    Height = 13
    Caption = 'Расчётные данные'
  end
  object Label7: TLabel
    Left = 8
    Top = 344
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
    Left = 11
    Top = 71
    Width = 326
    Height = 47
    Caption = 'Период'
    TabOrder = 3
    object lbBirthDateFrom: TLabel
      Left = 12
      Top = 21
      Width = 9
      Height = 13
      Caption = 'с:'
    end
    object lbBirthDateTo: TLabel
      Left = 146
      Top = 21
      Width = 15
      Height = 13
      Caption = 'по:'
    end
    object dtpBirthDateFrom: TDateTimePicker
      Left = 29
      Top = 17
      Width = 108
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
      Left = 168
      Top = 17
      Width = 117
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
      Left = 293
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
    Left = 376
    Top = 344
    Width = 123
    Height = 25
    Caption = 'Выполнить расчёт'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
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
    Left = 216
    Top = 128
    Width = 121
    Height = 21
    ButtonKind = bkStandard
    MaxValue = 100
    MinValue = 1
    Value = 100
    TabOrder = 5
  end
  object ListBox1: TListBox
    Left = 344
    Top = 24
    Width = 233
    Height = 82
    ItemHeight = 13
    Items.Strings = (
      'Расчёт пособия по общему заболеванию'
      'Расчёт пособия по уходу за больным'
      'Расчёт пособия при бытовой травме'
      'Расчёт пособия по беременности и родам'
      'Расчёт пособия при рождении ребёнка'
      'Расчёт пособия  по проф. заболеванию')
    TabOrder = 7
  end
  object CheckBox1: TCheckBox
    Left = 120
    Top = 152
    Width = 97
    Height = 17
    Caption = 'Без оплаты'
    TabOrder = 6
  end
  object CurrencyEdit1: TCurrencyEdit
    Left = 104
    Top = 320
    Width = 121
    Height = 21
    AutoSize = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 10
  end
  object RadioGroup1: TRadioGroup
    Left = 344
    Top = 120
    Width = 233
    Height = 57
    Items.Strings = (
      'Простой смертный'
      'Одинокие, вдовы и т.д.'
      'Ребёнок до 3-х, инвалид до 16-ти')
    TabOrder = 8
  end
  object RadioGroup2: TRadioGroup
    Left = 8
    Top = 128
    Width = 105
    Height = 49
    Hint = 'Выберите необходимый тип расчёта'
    Caption = 'Тип расчёта'
    Items.Strings = (
      'По дням'
      'По часам')
    TabOrder = 4
  end
  object RxDBGrid1: TRxDBGrid
    Left = 8
    Top = 200
    Width = 569
    Height = 113
    Color = clBtnFace
    DataSource = dsData
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 9
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Button2: TButton
    Left = 504
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Закрыть'
    TabOrder = 13
    OnClick = Button2Click
  end
  object CurrencyEdit2: TCurrencyEdit
    Left = 104
    Top = 344
    Width = 121
    Height = 21
    AutoSize = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 11
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
    Top = 240
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
    Top = 264
  end
end
