inherited fmEditRBEmpLeave: TfmEditRBEmpLeave
  Left = 322
  Top = 179
  Caption = 'fmEditRBEmpLeave'
  ClientHeight = 270
  ClientWidth = 334
  PixelsPerInch = 96
  TextHeight = 13
  object lbDocum: TLabel [0]
    Left = 57
    Top = 12
    Width = 74
    Height = 13
    Caption = 'На основании:'
  end
  object lbDateStart: TLabel [1]
    Left = 64
    Top = 145
    Width = 67
    Height = 13
    Caption = 'Дата начала:'
  end
  object lbForPeriod: TLabel [2]
    Left = 67
    Top = 91
    Width = 64
    Height = 13
    Caption = 'За период с:'
  end
  object lbTypeLeave: TLabel [3]
    Left = 66
    Top = 38
    Width = 65
    Height = 13
    Caption = 'Вид отпуска:'
  end
  object lbForPeriodOn: TLabel [4]
    Left = 61
    Top = 118
    Width = 70
    Height = 13
    Caption = 'За период по:'
  end
  object lbMainAmountCalDay: TLabel [5]
    Left = 45
    Top = 172
    Width = 86
    Height = 13
    Caption = 'Дней основного:'
  end
  object lbAddAmountCalDay: TLabel [6]
    Left = 10
    Top = 198
    Width = 121
    Height = 13
    Caption = 'Дней дополнительного:'
  end
  object lbAbsence: TLabel [7]
    Left = 71
    Top = 64
    Width = 61
    Height = 13
    Caption = 'Вид неявки:'
  end
  inherited pnBut: TPanel
    Top = 232
    Width = 334
    TabOrder = 12
    inherited Panel2: TPanel
      Left = 149
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 217
    TabOrder = 11
  end
  object edDocum: TEdit [10]
    Left = 139
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edDocumChange
  end
  object bibDocum: TBitBtn [11]
    Left = 308
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibDocumClick
  end
  object dtpDateStart: TDateTimePicker [12]
    Left = 139
    Top = 141
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 8
    OnChange = edDocumChange
  end
  object dtpForPeriod: TDateTimePicker [13]
    Left = 139
    Top = 87
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
    OnChange = edDocumChange
  end
  object edTypeLeave: TEdit [14]
    Left = 139
    Top = 35
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edDocumChange
  end
  object bibTypeLeave: TBitBtn [15]
    Left = 308
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibTypeLeaveClick
  end
  object dtpForPeriodOn: TDateTimePicker [16]
    Left = 139
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
    TabOrder = 7
    OnChange = edDocumChange
  end
  object edMainAmountCalDay: TEdit [17]
    Left = 138
    Top = 168
    Width = 87
    Height = 21
    MaxLength = 30
    TabOrder = 9
    OnChange = edDocumChange
    OnKeyPress = edMainAmountCalDayKeyPress
  end
  object edAddAmountCalDay: TEdit [18]
    Left = 138
    Top = 194
    Width = 87
    Height = 21
    MaxLength = 30
    TabOrder = 10
    OnChange = edDocumChange
    OnKeyPress = edMainAmountCalDayKeyPress
  end
  object edAbsence: TEdit [19]
    Left = 139
    Top = 61
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
  end
  object bibAbsence: TBitBtn [20]
    Left = 308
    Top = 61
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibAbsenceClick
  end
  inherited IBTran: TIBTransaction
    Left = 280
    Top = 115
  end
end
