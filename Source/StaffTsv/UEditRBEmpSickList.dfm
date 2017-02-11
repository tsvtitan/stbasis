inherited fmEditRBEmpSickList: TfmEditRBEmpSickList
  Left = 322
  Top = 179
  Caption = 'fmEditRBEmpSickList'
  ClientHeight = 223
  ClientWidth = 312
  PixelsPerInch = 96
  TextHeight = 13
  object lbNum: TLabel [0]
    Left = 47
    Top = 39
    Width = 57
    Height = 13
    Caption = 'Номер б/л:'
  end
  object lbPercent: TLabel [1]
    Left = 12
    Top = 145
    Width = 92
    Height = 13
    Caption = 'Процент доплаты:'
  end
  object lbSick: TLabel [2]
    Left = 58
    Top = 12
    Width = 46
    Height = 13
    Caption = 'Болезнь:'
  end
  object lbDateStart: TLabel [3]
    Left = 37
    Top = 91
    Width = 67
    Height = 13
    Caption = 'Дата начала:'
  end
  object lbDateFinish: TLabel [4]
    Left = 19
    Top = 116
    Width = 85
    Height = 13
    Caption = 'Дата окончания:'
  end
  object lbAbsence: TLabel [5]
    Left = 44
    Top = 64
    Width = 61
    Height = 13
    Caption = 'Вид неявки:'
  end
  inherited pnBut: TPanel
    Top = 185
    Width = 312
    TabOrder = 9
    inherited Panel2: TPanel
      Left = 127
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 168
    TabOrder = 8
  end
  object edNum: TEdit [8]
    Left = 112
    Top = 35
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 2
    OnChange = edSickChange
  end
  object edPercent: TEdit [9]
    Left = 112
    Top = 141
    Width = 88
    Height = 21
    MaxLength = 30
    TabOrder = 7
    OnChange = edSickChange
    OnKeyPress = edPercentKeyPress
  end
  object edSick: TEdit [10]
    Left = 112
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edSickChange
  end
  object bibSick: TBitBtn [11]
    Left = 281
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibSickClick
  end
  object dtpDateStart: TDateTimePicker [12]
    Left = 112
    Top = 87
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
    OnChange = edSickChange
  end
  object dtpDateFinish: TDateTimePicker [13]
    Left = 112
    Top = 114
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 6
    OnChange = edSickChange
  end
  object edAbsence: TEdit [14]
    Left = 112
    Top = 61
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 3
  end
  object bibAbsence: TBitBtn [15]
    Left = 281
    Top = 61
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 4
    OnClick = bibAbsenceClick
  end
  inherited IBTran: TIBTransaction
    Left = 240
    Top = 111
  end
end
