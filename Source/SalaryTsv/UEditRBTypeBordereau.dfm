inherited fmEditRBTypeBordereau: TfmEditRBTypeBordereau
  Left = 381
  Top = 166
  Caption = 'fmEditRBTypeBordereau'
  ClientHeight = 266
  ClientWidth = 303
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 11
    Top = 12
    Width = 79
    Height = 13
    Caption = 'Наименование:'
  end
  object lbChargeName: TLabel [1]
    Left = 6
    Top = 38
    Width = 84
    Height = 13
    Caption = 'Вид начисления:'
  end
  object lbPeriodsBack: TLabel [2]
    Left = 52
    Top = 66
    Width = 162
    Height = 13
    Caption = 'Сколько брать периодов назад:'
  end
  object lbPercent: TLabel [3]
    Left = 104
    Top = 92
    Width = 110
    Height = 13
    Caption = 'Какой брать процент:'
  end
  inherited pnBut: TPanel
    Top = 228
    Width = 303
    TabOrder = 8
    inherited Panel2: TPanel
      Left = 118
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 210
    TabOrder = 7
  end
  object edName: TEdit [6]
    Left = 97
    Top = 9
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
  end
  object edChargeName: TEdit [7]
    Left = 97
    Top = 35
    Width = 178
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 1
    OnChange = edNameChange
    OnKeyDown = edChargeNameKeyDown
  end
  object bibChargeName: TBitBtn [8]
    Left = 275
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 2
    OnClick = bibChargeNameClick
  end
  object edPeriodsBack: TEdit [9]
    Left = 222
    Top = 62
    Width = 59
    Height = 21
    MaxLength = 6
    ReadOnly = True
    TabOrder = 3
    Text = '0'
    OnChange = edNameChange
  end
  object udPeriodsBack: TUpDown [10]
    Left = 281
    Top = 62
    Width = 15
    Height = 21
    Associate = edPeriodsBack
    Min = 0
    Position = 0
    TabOrder = 4
    Wrap = False
  end
  object edPercent: TEdit [11]
    Left = 222
    Top = 89
    Width = 74
    Height = 21
    MaxLength = 15
    TabOrder = 5
    OnChange = edNameChange
    OnKeyPress = edPercentKeyPress
  end
  object grbPeriods: TGroupBox [12]
    Left = 8
    Top = 112
    Width = 288
    Height = 95
    Caption = ' Периоды '
    TabOrder = 6
    object lbPeriods: TListBox
      Left = 9
      Top = 17
      Width = 240
      Height = 69
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
    end
    object bibAddPeriod: TBitBtn
      Left = 256
      Top = 25
      Width = 21
      Height = 21
      Hint = 'Добавить период'
      Caption = '<--'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = bibAddPeriodClick
    end
    object bibDelPeriod: TBitBtn
      Left = 256
      Top = 53
      Width = 21
      Height = 21
      Hint = 'Удалить период'
      Caption = '-->'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = bibDelPeriodClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 8
    Top = 66
  end
end
