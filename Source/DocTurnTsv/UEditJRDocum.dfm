inherited fmEditJRDocum: TfmEditJRDocum
  Left = 542
  Top = 264
  Caption = 'fmEditJRDocum'
  ClientHeight = 231
  ClientWidth = 311
  PixelsPerInch = 96
  TextHeight = 13
  object lbTypeDocName: TLabel [0]
    Left = 7
    Top = 14
    Width = 79
    Height = 13
    Caption = 'Вид документа:'
  end
  inherited pnBut: TPanel
    Top = 193
    Width = 311
    TabOrder = 5
    inherited Panel2: TPanel
      Left = 126
    end
  end
  inherited cbInString: TCheckBox
    Top = 176
    TabOrder = 4
  end
  object edTypeDocName: TEdit [3]
    Left = 96
    Top = 11
    Width = 185
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edTypeDocNameChange
  end
  object bibTypeDocName: TBitBtn [4]
    Left = 281
    Top = 11
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibTypeDocNameClick
  end
  object grbDate: TGroupBox [5]
    Left = 7
    Top = 120
    Width = 295
    Height = 54
    Caption = ' Дата документа '
    TabOrder = 3
    object lbDateFrom: TLabel
      Left = 14
      Top = 23
      Width = 9
      Height = 13
      Caption = 'c:'
    end
    object lbDateTo: TLabel
      Left = 137
      Top = 23
      Width = 15
      Height = 13
      Caption = 'по:'
    end
    object dtpDateFrom: TDateTimePicker
      Left = 30
      Top = 20
      Width = 97
      Height = 22
      CalAlignment = dtaLeft
      Date = 37135
      Time = 37135
      ShowCheckbox = True
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 0
      OnChange = dtpDateFromChange
    end
    object dtpDateTo: TDateTimePicker
      Left = 161
      Top = 20
      Width = 97
      Height = 22
      CalAlignment = dtaLeft
      Date = 37135.9999884259
      Time = 37135.9999884259
      ShowCheckbox = True
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 1
      OnChange = dtpDateFromChange
    end
    object bibDate: TBitBtn
      Left = 263
      Top = 20
      Width = 21
      Height = 21
      Caption = '...'
      TabOrder = 2
      OnClick = bibDateClick
    end
  end
  object grbNum: TGroupBox [6]
    Left = 8
    Top = 38
    Width = 294
    Height = 77
    Caption = ' Номер документа '
    TabOrder = 2
    object lbNum: TLabel
      Left = 23
      Top = 21
      Width = 37
      Height = 13
      Caption = 'Номер:'
    end
    object lbPrefix: TLabel
      Left = 11
      Top = 48
      Width = 49
      Height = 13
      Caption = 'Префикс:'
    end
    object lbSufix: TLabel
      Left = 154
      Top = 48
      Width = 49
      Height = 13
      Caption = 'Суффикс:'
    end
    object edNum: TEdit
      Left = 66
      Top = 18
      Width = 195
      Height = 21
      MaxLength = 100
      TabOrder = 0
      OnChange = edTypeDocNameChange
      OnKeyPress = edNumKeyPress
    end
    object edPrefix: TEdit
      Left = 66
      Top = 45
      Width = 74
      Height = 21
      MaxLength = 100
      TabOrder = 2
      OnChange = edTypeDocNameChange
    end
    object edSufix: TEdit
      Left = 210
      Top = 45
      Width = 72
      Height = 21
      MaxLength = 100
      TabOrder = 3
      OnChange = edTypeDocNameChange
    end
    object bibNum: TBitBtn
      Left = 261
      Top = 18
      Width = 21
      Height = 21
      Hint = 'Следующий номер'
      Caption = '<-'
      TabOrder = 1
    end
  end
  inherited IBTran: TIBTransaction
    Left = 168
    Top = 23
  end
end
