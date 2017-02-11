inherited fmRptTest: TfmRptTest
  Caption = 'Тестовый отчет'
  PixelsPerInch = 96
  TextHeight = 13
  inherited cbInString: TCheckBox
    TabOrder = 4
  end
  object DateTimePicker1: TDateTimePicker [2]
    Left = 32
    Top = 32
    Width = 81
    Height = 21
    CalAlignment = dtaLeft
    Date = 37192.5750840625
    Time = 37192.5750840625
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
  end
  object DateTimePicker2: TDateTimePicker [3]
    Left = 120
    Top = 32
    Width = 97
    Height = 21
    CalAlignment = dtaLeft
    Date = 37192.5751074768
    Time = 37192.5751074768
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 2
  end
  object Button1: TButton [4]
    Left = 232
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
end
