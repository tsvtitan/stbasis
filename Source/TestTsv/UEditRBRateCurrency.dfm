inherited fmEditRBRateCurrency: TfmEditRBRateCurrency
  Caption = 'fmEditRBRateCurrency'
  ClientHeight = 113
  ClientWidth = 303
  PixelsPerInch = 96
  TextHeight = 13
  object lbFactor: TLabel [0]
    Left = 6
    Top = 39
    Width = 73
    Height = 13
    Caption = 'Коэффициент:'
  end
  object lbCurrency: TLabel [1]
    Left = 38
    Top = 12
    Width = 41
    Height = 13
    Caption = 'Валюта:'
  end
  object lbInDate: TLabel [2]
    Left = 178
    Top = 38
    Width = 29
    Height = 13
    Caption = 'Дата:'
  end
  inherited pnBut: TPanel
    Top = 75
    Width = 303
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 118
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 58
    TabOrder = 4
  end
  object edFactor: TEdit [5]
    Left = 84
    Top = 35
    Width = 83
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edFactorChange
    OnKeyPress = edFactorKeyPress
  end
  object edCurrency: TEdit [6]
    Left = 84
    Top = 8
    Width = 189
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
  end
  object bibCurrency: TBitBtn [7]
    Left = 273
    Top = 8
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibCurrencyClick
  end
  object dtpInDate: TDateTimePicker [8]
    Left = 212
    Top = 35
    Width = 83
    Height = 21
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = True
    TabOrder = 3
    OnChange = dtpInDateChange
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 73
  end
end
