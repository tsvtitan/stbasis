object fmEnterPeriod: TfmEnterPeriod
  Left = 408
  Top = 159
  BorderStyle = bsDialog
  Caption = 'Выбор периода'
  ClientHeight = 203
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbBegin: TLabel
    Left = 96
    Top = 114
    Width = 9
    Height = 13
    Caption = 'c:'
  end
  object lbEnd: TLabel
    Left = 90
    Top = 138
    Width = 15
    Height = 13
    Caption = 'по:'
  end
  object dtpBegin: TDateTimePicker
    Left = 112
    Top = 110
    Width = 133
    Height = 21
    CalAlignment = dtaLeft
    Date = 36907.4465602199
    Time = 36907.4465602199
    DateFormat = dfLong
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 12
  end
  object Panel1: TPanel
    Left = 0
    Top = 159
    Width = 256
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 14
    object bibOk: TButton
      Left = 92
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = bibOkClick
    end
    object bibCancel: TButton
      Left = 174
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Отмена'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object dtpEnd: TDateTimePicker
    Left = 112
    Top = 134
    Width = 133
    Height = 21
    CalAlignment = dtaLeft
    Date = 36907.4465602199
    Time = 36907.4465602199
    DateFormat = dfLong
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 13
  end
  object rbKvartal: TRadioButton
    Left = 8
    Top = 40
    Width = 76
    Height = 17
    Caption = 'Квартал:'
    TabOrder = 3
    OnClick = rbKvartalClick
  end
  object rbMonth: TRadioButton
    Left = 8
    Top = 64
    Width = 76
    Height = 17
    Caption = 'Месяц:'
    TabOrder = 6
    OnClick = rbKvartalClick
  end
  object rbDay: TRadioButton
    Left = 8
    Top = 88
    Width = 76
    Height = 17
    Caption = 'День:'
    TabOrder = 9
    OnClick = rbKvartalClick
  end
  object rbInterval: TRadioButton
    Left = 8
    Top = 112
    Width = 76
    Height = 17
    Caption = 'Интервал:'
    TabOrder = 11
    OnClick = rbKvartalClick
  end
  object edKvartal: TEdit
    Left = 112
    Top = 38
    Width = 117
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = '0'
    OnChange = edKvartalChange
  end
  object udKvartal: TUpDown
    Left = 229
    Top = 38
    Width = 15
    Height = 21
    Associate = edKvartal
    Min = -4
    Max = 4
    Position = 0
    TabOrder = 5
    Wrap = False
    OnChangingEx = udKvartalChangingEx
  end
  object edMonth: TEdit
    Left = 112
    Top = 62
    Width = 117
    Height = 21
    ReadOnly = True
    TabOrder = 7
    Text = '0'
    OnChange = edMonthChange
  end
  object udMonth: TUpDown
    Left = 229
    Top = 62
    Width = 15
    Height = 21
    Associate = edMonth
    Min = -4
    Max = 4
    Position = 0
    TabOrder = 8
    Wrap = False
    OnChangingEx = udMonthChangingEx
  end
  object dtpDay: TDateTimePicker
    Left = 112
    Top = 86
    Width = 133
    Height = 21
    CalAlignment = dtaLeft
    Date = 36907.4465602199
    Time = 36907.4465602199
    DateFormat = dfLong
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 10
  end
  object rbYear: TRadioButton
    Left = 8
    Top = 16
    Width = 76
    Height = 17
    Caption = 'Год:'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = rbKvartalClick
  end
  object edYear: TEdit
    Left = 112
    Top = 14
    Width = 117
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = '2001'
    OnChange = edKvartalChange
  end
  object udYear: TUpDown
    Left = 229
    Top = 14
    Width = 16
    Height = 21
    Associate = edYear
    Min = 1950
    Max = 2050
    Position = 2001
    TabOrder = 2
    Thousands = False
    Wrap = False
    OnChangingEx = udYearChangingEx
  end
end
