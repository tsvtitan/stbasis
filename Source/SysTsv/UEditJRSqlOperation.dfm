inherited fmEditJRSqlOperation: TfmEditJRSqlOperation
  Left = 257
  Caption = 'fmEditJRSqlOperation'
  ClientHeight = 287
  ClientWidth = 296
  PixelsPerInch = 96
  TextHeight = 13
  object lbName: TLabel [0]
    Left = 8
    Top = 130
    Width = 53
    Height = 13
    Caption = 'Операция:'
  end
  object lbUsername: TLabel [1]
    Left = 7
    Top = 14
    Width = 76
    Height = 13
    Caption = 'Пользователь:'
  end
  object lbCompName: TLabel [2]
    Left = 22
    Top = 42
    Width = 61
    Height = 13
    Caption = 'Компьютер:'
  end
  inherited pnBut: TPanel
    Top = 249
    Width = 296
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 111
    end
  end
  inherited cbInString: TCheckBox
    Top = 232
    TabOrder = 6
  end
  object edName: TEdit [5]
    Left = 70
    Top = 127
    Width = 214
    Height = 21
    MaxLength = 100
    TabOrder = 4
  end
  object edUsername: TEdit [6]
    Left = 92
    Top = 11
    Width = 171
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
  end
  object bibUserName: TButton [7]
    Left = 263
    Top = 11
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = bibUserNameClick
  end
  object grbDate: TGroupBox [8]
    Left = 7
    Top = 64
    Width = 278
    Height = 54
    Caption = ' Дата '
    TabOrder = 3
    object lbDateFrom: TLabel
      Left = 16
      Top = 23
      Width = 9
      Height = 13
      Caption = 'c:'
    end
    object lbDateTo: TLabel
      Left = 144
      Top = 23
      Width = 15
      Height = 13
      Caption = 'по:'
    end
    object dtpDateFrom: TDateTimePicker
      Left = 32
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
    end
    object dtpDateTo: TDateTimePicker
      Left = 168
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
    end
  end
  object grbHint: TGroupBox [9]
    Left = 7
    Top = 152
    Width = 278
    Height = 76
    Caption = ' Описание '
    TabOrder = 5
    object meHint: TMemo
      Left = 8
      Top = 18
      Width = 261
      Height = 50
      MaxLength = 1000
      TabOrder = 0
    end
  end
  object edCompName: TEdit [10]
    Left = 92
    Top = 39
    Width = 191
    Height = 21
    MaxLength = 100
    TabOrder = 2
  end
  inherited IBTran: TIBTransaction
    Left = 96
    Top = 255
  end
end
