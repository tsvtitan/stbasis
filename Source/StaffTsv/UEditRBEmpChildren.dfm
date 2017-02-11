inherited fmEditRBEmpChildren: TfmEditRBEmpChildren
  Left = 306
  Caption = 'fmEditRBEmpChildren'
  ClientHeight = 247
  ClientWidth = 289
  PixelsPerInch = 96
  TextHeight = 13
  object lbSex: TLabel [0]
    Left = 67
    Top = 232
    Width = 23
    Height = 13
    Caption = 'Пол:'
    Visible = False
  end
  object lbFname: TLabel [1]
    Left = 38
    Top = 15
    Width = 52
    Height = 13
    Caption = 'Фамилия:'
  end
  object lbname: TLabel [2]
    Left = 65
    Top = 41
    Width = 25
    Height = 13
    Caption = 'Имя:'
  end
  object lbsname: TLabel [3]
    Left = 40
    Top = 67
    Width = 50
    Height = 13
    Caption = 'Отчество:'
  end
  object lbbirthdate: TLabel [4]
    Left = 8
    Top = 93
    Width = 82
    Height = 13
    Caption = 'Дата рождения:'
  end
  object lbAddress: TLabel [5]
    Left = 56
    Top = 120
    Width = 34
    Height = 13
    Caption = 'Адрес:'
  end
  object lbWorkPlace: TLabel [6]
    Left = 15
    Top = 138
    Width = 75
    Height = 26
    Alignment = taRightJustify
    Caption = 'Место работы или учебы:'
    WordWrap = True
  end
  object lbTypeRelation: TLabel [7]
    Left = 34
    Top = 174
    Width = 56
    Height = 13
    Caption = 'Категория:'
  end
  object bibSex: TBitBtn [8]
    Left = 259
    Top = 228
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 9
    Visible = False
    OnClick = bibSexClick
  end
  object edSex: TEdit [9]
    Left = 96
    Top = 228
    Width = 163
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 8
    Visible = False
  end
  inherited pnBut: TPanel
    Top = 209
    Width = 289
    TabOrder = 11
    inherited Panel2: TPanel
      Left = 104
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 192
    TabOrder = 10
  end
  object edFName: TEdit [12]
    Left = 96
    Top = 11
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edFNameChange
  end
  object edname: TEdit [13]
    Left = 96
    Top = 37
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 1
    OnChange = edFNameChange
  end
  object edsname: TEdit [14]
    Left = 96
    Top = 63
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edFNameChange
  end
  object dtpBirthdate: TDateTimePicker [15]
    Left = 96
    Top = 89
    Width = 83
    Height = 21
    CalAlignment = dtaLeft
    Date = 37147
    Time = 37147
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 3
    OnChange = dtpBirthdateChange
  end
  object edAddress: TEdit [16]
    Left = 96
    Top = 116
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 4
    OnChange = edFNameChange
  end
  object edWorkPlace: TEdit [17]
    Left = 96
    Top = 143
    Width = 184
    Height = 21
    MaxLength = 100
    TabOrder = 5
    OnChange = edFNameChange
  end
  object edTypeRelation: TEdit [18]
    Left = 96
    Top = 170
    Width = 163
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
  end
  object bibTypeRelation: TBitBtn [19]
    Left = 259
    Top = 170
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibTypeRelationClick
  end
  inherited IBTran: TIBTransaction
    Left = 88
    Top = 217
  end
end
