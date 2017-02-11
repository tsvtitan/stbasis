inherited fmRptEmpUniversal: TfmRptEmpUniversal
  Left = 289
  Top = 123
  Caption = 'Универсальный отчет по сотрудникам'
  ClientHeight = 312
  PixelsPerInch = 96
  TextHeight = 13
  object lbFName: TLabel [0]
    Left = 12
    Top = 12
    Width = 52
    Height = 13
    Caption = 'Фамилия:'
  end
  object lbName: TLabel [1]
    Left = 39
    Top = 36
    Width = 25
    Height = 13
    Caption = 'Имя:'
  end
  object lbSName: TLabel [2]
    Left = 14
    Top = 60
    Width = 50
    Height = 13
    Caption = 'Отчество:'
  end
  object lbSex: TLabel [3]
    Left = 69
    Top = 84
    Width = 23
    Height = 13
    Caption = 'Пол:'
  end
  object lbPerscardnum: TLabel [4]
    Left = 63
    Top = 160
    Width = 124
    Height = 13
    Caption = 'Номер личной карточки:'
  end
  object lbFamilyStateName: TLabel [5]
    Left = 74
    Top = 207
    Width = 113
    Height = 13
    Caption = 'Семейное положение:'
  end
  object lbNationname: TLabel [6]
    Left = 99
    Top = 231
    Width = 88
    Height = 13
    Caption = 'Национальность:'
  end
  object lbBorntownname: TLabel [7]
    Left = 99
    Top = 255
    Width = 88
    Height = 13
    Caption = 'Место рождения:'
    Enabled = False
    Visible = False
  end
  object lbInn: TLabel [8]
    Left = 160
    Top = 184
    Width = 27
    Height = 13
    Caption = 'ИНН:'
  end
  inherited pnBut: TPanel
    Top = 274
    TabOrder = 15
    inherited Panel2: TPanel
      inherited bibClear: TBitBtn
        Hint = 'Значения по умолчанию'
        Caption = 'По умолчанию'
        Visible = True
      end
    end
  end
  inherited cbInString: TCheckBox
    Top = 257
    TabOrder = 14
    Visible = True
  end
  object edFname: TEdit [11]
    Left = 71
    Top = 8
    Width = 208
    Height = 21
    MaxLength = 100
    TabOrder = 0
  end
  object edName: TEdit [12]
    Left = 71
    Top = 32
    Width = 208
    Height = 21
    MaxLength = 30
    TabOrder = 1
  end
  object edSname: TEdit [13]
    Left = 71
    Top = 56
    Width = 208
    Height = 21
    MaxLength = 30
    TabOrder = 2
  end
  object edPerscardnum: TEdit [14]
    Left = 194
    Top = 156
    Width = 180
    Height = 21
    MaxLength = 30
    TabOrder = 6
  end
  object edFamilyStateName: TEdit [15]
    Left = 194
    Top = 204
    Width = 159
    Height = 21
    MaxLength = 100
    TabOrder = 8
  end
  object bibFamilyStateName: TBitBtn [16]
    Left = 353
    Top = 204
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 9
    OnClick = bibFamilyStateNameClick
  end
  object edNationname: TEdit [17]
    Left = 194
    Top = 228
    Width = 159
    Height = 21
    MaxLength = 100
    TabOrder = 10
  end
  object bibNationname: TBitBtn [18]
    Left = 353
    Top = 228
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 11
    OnClick = bibNationnameClick
  end
  object edBorntownname: TEdit [19]
    Left = 194
    Top = 252
    Width = 159
    Height = 21
    Enabled = False
    MaxLength = 100
    TabOrder = 12
    Visible = False
  end
  object bibBorntownname: TBitBtn [20]
    Left = 353
    Top = 252
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    Enabled = False
    TabOrder = 13
    Visible = False
    OnClick = bibBorntownnameClick
  end
  object edSex: TEdit [21]
    Left = 99
    Top = 80
    Width = 159
    Height = 21
    MaxLength = 100
    TabOrder = 3
  end
  object bibSex: TBitBtn [22]
    Left = 258
    Top = 80
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 4
    OnClick = bibSexClick
  end
  object edInn: TEdit [23]
    Left = 194
    Top = 180
    Width = 180
    Height = 21
    MaxLength = 30
    TabOrder = 7
  end
  object grbBirthDate: TGroupBox [24]
    Left = 99
    Top = 103
    Width = 276
    Height = 47
    Caption = ' Дата рождения '
    TabOrder = 5
    object lbBirthDateFrom: TLabel
      Left = 12
      Top = 21
      Width = 9
      Height = 13
      Caption = 'с:'
    end
    object lbBirthDateTo: TLabel
      Left = 130
      Top = 21
      Width = 15
      Height = 13
      Caption = 'по:'
    end
    object dtpBirthDateFrom: TDateTimePicker
      Left = 29
      Top = 17
      Width = 94
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
      TabOrder = 0
    end
    object dtpBirthDateTo: TDateTimePicker
      Left = 151
      Top = 17
      Width = 94
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
      TabOrder = 1
    end
    object bibBirthDate: TBitBtn
      Left = 245
      Top = 17
      Width = 21
      Height = 21
      Hint = 'Выбрать'
      Caption = '...'
      TabOrder = 2
      OnClick = bibBirthDateClick
    end
  end
  inherited IBTran: TIBTransaction
    Left = 48
    Top = 121
  end
  inherited Mainqr: TIBQuery
    Left = 8
    Top = 120
  end
end
