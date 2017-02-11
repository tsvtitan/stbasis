inherited fmEditRBBlackList: TfmEditRBBlackList
  Left = 345
  Top = 160
  Caption = 'fmEditRBBlackList'
  ClientHeight = 320
  ClientWidth = 327
  PixelsPerInch = 96
  TextHeight = 13
  object lbBlackString: TLabel [0]
    Left = 10
    Top = 11
    Width = 103
    Height = 13
    Caption = 'Строка исключения:'
    FocusControl = edBlackString
  end
  object lbDateBegin: TLabel [1]
    Left = 94
    Top = 218
    Width = 117
    Height = 13
    Alignment = taRightJustify
    Caption = 'Дата начала действия:'
    FocusControl = dtpDateBegin
  end
  object lbDateEnd: TLabel [2]
    Left = 76
    Top = 246
    Width = 135
    Height = 13
    Alignment = taRightJustify
    Caption = 'Дата окончания действия:'
    FocusControl = dtpDateEnd
  end
  object lbAbout: TLabel [3]
    Left = 47
    Top = 96
    Width = 66
    Height = 13
    Caption = 'Примечание:'
    FocusControl = meAbout
  end
  inherited pnBut: TPanel
    Top = 282
    Width = 327
    TabOrder = 8
    inherited Panel2: TPanel
      Left = 142
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 266
    TabOrder = 7
  end
  object edBlackString: TEdit [6]
    Left = 124
    Top = 7
    Width = 193
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edBlackStringChange
  end
  object chbInLast: TCheckBox [7]
    Left = 124
    Top = 52
    Width = 145
    Height = 17
    Caption = 'Встречается в конце'
    TabOrder = 2
    OnClick = chbInFirstClick
  end
  object dtpDateBegin: TDateTimePicker [8]
    Left = 222
    Top = 214
    Width = 95
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
    TabOrder = 5
    OnChange = edBlackStringChange
  end
  object dtpDateEnd: TDateTimePicker [9]
    Left = 222
    Top = 242
    Width = 95
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
    TabOrder = 6
    OnChange = edBlackStringChange
  end
  object chbInFirst: TCheckBox [10]
    Left = 124
    Top = 32
    Width = 149
    Height = 17
    Caption = 'Встречается сначала'
    TabOrder = 1
    OnClick = chbInFirstClick
  end
  object chbInAll: TCheckBox [11]
    Left = 124
    Top = 72
    Width = 145
    Height = 17
    Caption = 'Встречается везде'
    TabOrder = 3
    OnClick = chbInFirstClick
  end
  object meAbout: TMemo [12]
    Left = 124
    Top = 94
    Width = 193
    Height = 113
    TabOrder = 4
    OnChange = edBlackStringChange
  end
  inherited IBTran: TIBTransaction
    Top = 161
  end
end
