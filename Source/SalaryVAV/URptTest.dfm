inherited fmRptTest: TfmRptTest
  Caption = 'Тестовый отчет'
  ClientHeight = 390
  ClientWidth = 537
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 160
    Top = 136
    Width = 89
    Height = 13
    Caption = 'Выбирете период'
  end
  inherited pnBut: TPanel
    Top = 352
    Width = 537
    inherited Panel2: TPanel
      Left = 151
    end
  end
  inherited cbInString: TCheckBox
    TabOrder = 4
  end
  object DateTimePicker1: TDateTimePicker [3]
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
  object DateTimePicker2: TDateTimePicker [4]
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
  object Button1: TButton [5]
    Left = 312
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox [6]
    Left = 144
    Top = 160
    Width = 105
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = 'ComboBox1'
  end
  object SpinEdit1: TSpinEdit [7]
    Left = 264
    Top = 160
    Width = 65
    Height = 22
    MaxValue = 2010
    MinValue = 2000
    TabOrder = 6
    Value = 2001
  end
  object Button2: TButton [8]
    Left = 384
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Рассчет'
    TabOrder = 7
    OnClick = Button2Click
  end
  object BibSal: TBitBtn [9]
    Left = 262
    Top = 242
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 8
    OnClick = BibSalClick
  end
  object edschedule: TEdit [10]
    Left = 24
    Top = 240
    Width = 121
    Height = 21
    TabOrder = 9
  end
end
