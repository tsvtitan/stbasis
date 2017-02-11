inherited fmEditRBAddConstCharge: TfmEditRBAddConstCharge
  Left = 393
  Top = 212
  Caption = 'fmEditRBAddConstCharge'
  ClientHeight = 168
  ClientWidth = 307
  PixelsPerInch = 96
  TextHeight = 13
  object lbCharge: TLabel [0]
    Left = 22
    Top = 11
    Width = 64
    Height = 13
    Caption = 'Начисление:'
  end
  object lbSumma: TLabel [1]
    Left = 49
    Top = 33
    Width = 37
    Height = 13
    Caption = 'Сумма:'
    Enabled = False
    Visible = False
  end
  object lbPercent: TLabel [2]
    Left = 40
    Top = 57
    Width = 46
    Height = 13
    Caption = 'Процент:'
    Enabled = False
    Visible = False
  end
  object Label2: TLabel [3]
    Left = 12
    Top = 80
    Width = 72
    Height = 13
    Caption = 'Начинается с:'
  end
  object Label3: TLabel [4]
    Left = 4
    Top = 103
    Width = 80
    Height = 13
    Caption = 'Закончивается:'
  end
  inherited pnBut: TPanel
    Top = 130
    Width = 307
    TabOrder = 6
    inherited Panel2: TPanel
      Left = 122
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 265
    TabOrder = 7
  end
  object edCharge: TEdit [7]
    Left = 88
    Top = 7
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnKeyDown = edChargeKeyDown
  end
  object bibCharge: TBitBtn [8]
    Left = 257
    Top = 7
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibChargeClick
  end
  object dtpStartDate: TDateTimePicker [9]
    Left = 87
    Top = 76
    Width = 191
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
    TabOrder = 4
  end
  object dtpEndDate: TDateTimePicker [10]
    Left = 87
    Top = 100
    Width = 191
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
    TabOrder = 5
  end
  object cedPercent: TCurrencyEdit [11]
    Left = 88
    Top = 54
    Width = 191
    Height = 21
    AutoSize = False
    Enabled = False
    TabOrder = 3
    Visible = False
  end
  object cedSumma: TCurrencyEdit [12]
    Left = 88
    Top = 30
    Width = 191
    Height = 21
    AutoSize = False
    Enabled = False
    TabOrder = 2
    Visible = False
  end
  inherited IBTran: TIBTransaction
    Left = 10
    Top = 144
  end
end
