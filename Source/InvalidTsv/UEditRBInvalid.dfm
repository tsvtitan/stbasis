inherited fmEditRBInvalid: TfmEditRBInvalid
  Left = 650
  Top = 172
  Caption = 'fmEditRBInvalid'
  ClientHeight = 272
  ClientWidth = 290
  PixelsPerInch = 96
  TextHeight = 13
  object lbfname: TLabel [0]
    Left = 19
    Top = 13
    Width = 52
    Height = 13
    Alignment = taRightJustify
    Caption = 'Фамилия:'
  end
  object lbName: TLabel [1]
    Left = 46
    Top = 39
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = 'Имя:'
  end
  object lbsname: TLabel [2]
    Left = 21
    Top = 66
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = 'Отчество:'
  end
  object lbAddress: TLabel [3]
    Left = 37
    Top = 121
    Width = 34
    Height = 13
    Alignment = taRightJustify
    Caption = 'Адрес:'
  end
  object lbBirthDate: TLabel [4]
    Left = 133
    Top = 93
    Width = 74
    Height = 13
    Alignment = taRightJustify
    Caption = 'Год рождения:'
  end
  inherited pnBut: TPanel
    Top = 234
    Width = 290
    TabOrder = 11
    inherited Panel2: TPanel
      Left = 105
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 218
    TabOrder = 10
  end
  object edfname: TEdit [7]
    Left = 81
    Top = 9
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edfnameChange
  end
  object edname: TEdit [8]
    Left = 81
    Top = 35
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edfnameChange
  end
  object edsname: TEdit [9]
    Left = 81
    Top = 62
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edfnameChange
  end
  object edAddress: TEdit [10]
    Left = 81
    Top = 117
    Width = 199
    Height = 21
    MaxLength = 100
    TabOrder = 5
    OnChange = edfnameChange
  end
  object dtpBirthDate: TDateTimePicker [11]
    Left = 9
    Top = 89
    Width = 119
    Height = 21
    CalAlignment = dtaLeft
    Date = 37640.7361182755
    Time = 37640.7361182755
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 3
    Visible = False
    OnChange = dtpBirthDateChange
  end
  object chbChildHood: TCheckBox [12]
    Left = 80
    Top = 141
    Width = 153
    Height = 17
    Caption = 'Инвалид детства'
    TabOrder = 6
    OnClick = chbChildHoodClick
  end
  object chbIVO: TCheckBox [13]
    Left = 80
    Top = 160
    Width = 159
    Height = 17
    Caption = 'ИВО'
    TabOrder = 7
    OnClick = chbChildHoodClick
  end
  object chbUVO: TCheckBox [14]
    Left = 80
    Top = 178
    Width = 159
    Height = 17
    Caption = 'УВО'
    TabOrder = 8
    OnClick = chbChildHoodClick
  end
  object chbAutotransport: TCheckBox [15]
    Left = 80
    Top = 197
    Width = 159
    Height = 17
    Caption = 'Автотранспорт'
    TabOrder = 9
    OnClick = chbChildHoodClick
  end
  object meYear: TMaskEdit [16]
    Left = 218
    Top = 89
    Width = 62
    Height = 21
    EditMask = '9999;1;_'
    MaxLength = 4
    TabOrder = 4
    Text = '    '
    OnChange = edfnameChange
    OnExit = meYearExit
  end
  inherited IBTran: TIBTransaction
    Left = 16
    Top = 146
  end
end
