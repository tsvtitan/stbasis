inherited fmEditRBAddCharge: TfmEditRBAddCharge
  Left = 308
  Top = 241
  Caption = 'fmEditRBAddCharge'
  ClientHeight = 217
  ClientWidth = 312
  PixelsPerInch = 96
  TextHeight = 13
  object lbTabelCol: TLabel [0]
    Left = 18
    Top = 54
    Width = 84
    Height = 13
    Caption = 'Колонка табеля:'
    Visible = False
  end
  object lbCalcPeriod: TLabel [1]
    Left = -1
    Top = 7
    Width = 103
    Height = 13
    Caption = 'Рассчетный период:'
  end
  object lbCharge: TLabel [2]
    Left = 38
    Top = 33
    Width = 64
    Height = 13
    Caption = 'Начисление:'
  end
  object lbSumma: TLabel [3]
    Left = 65
    Top = 82
    Width = 37
    Height = 13
    Caption = 'Сумма:'
    Enabled = False
    Visible = False
  end
  object lbPercent: TLabel [4]
    Left = 56
    Top = 109
    Width = 46
    Height = 13
    Caption = 'Процент:'
    Enabled = False
    Visible = False
  end
  object lbHours: TLabel [5]
    Left = 33
    Top = 129
    Width = 65
    Height = 13
    Caption = 'Норма часы:'
    Enabled = False
    Visible = False
  end
  object lbDays: TLabel [6]
    Left = 41
    Top = 152
    Width = 58
    Height = 13
    Caption = 'Норма дни:'
    Enabled = False
    Visible = False
  end
  inherited pnBut: TPanel
    Top = 179
    Width = 312
    TabOrder = 10
    inherited Panel2: TPanel
      Left = 127
    end
  end
  inherited cbInString: TCheckBox
    Left = 0
    Top = 337
    TabOrder = 11
  end
  object edCalcPeriod: TEdit [9]
    Left = 104
    Top = 5
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edStreetChange
  end
  object bibCalcperiod: TBitBtn [10]
    Left = 273
    Top = 5
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibCalcperiodClick
  end
  object edTabelCol: TEdit [11]
    Left = 104
    Top = 53
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    Visible = False
    OnChange = edStreetChange
    OnKeyDown = edTabelColKeyDown
  end
  object bibTabelCol: TBitBtn [12]
    Left = 273
    Top = 53
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    Visible = False
  end
  object edCharge: TEdit [13]
    Left = 104
    Top = 29
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edStreetChange
    OnKeyDown = edChargeKeyDown
  end
  object bibCharge: TBitBtn [14]
    Left = 273
    Top = 29
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibChargeClick
  end
  object cedPercent: TCurrencyEdit [15]
    Left = 104
    Top = 101
    Width = 190
    Height = 21
    AutoSize = False
    Enabled = False
    TabOrder = 7
    Visible = False
  end
  object cedHours: TCurrencyEdit [16]
    Left = 104
    Top = 125
    Width = 190
    Height = 21
    AutoSize = False
    Enabled = False
    TabOrder = 8
    Visible = False
  end
  object cedDays: TCurrencyEdit [17]
    Left = 104
    Top = 149
    Width = 190
    Height = 21
    AutoSize = False
    Enabled = False
    TabOrder = 9
    Visible = False
  end
  object cedSumma: TCurrencyEdit [18]
    Left = 104
    Top = 77
    Width = 190
    Height = 21
    AutoSize = False
    Enabled = False
    TabOrder = 6
    Visible = False
  end
  inherited IBTran: TIBTransaction
    Left = 10
    Top = 144
  end
end
