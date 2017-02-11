inherited fmEditRBEmpDiplom: TfmEditRBEmpDiplom
  Left = 289
  Top = 125
  Caption = 'fmEditRBEmpDiplom'
  ClientHeight = 279
  ClientWidth = 319
  PixelsPerInch = 96
  TextHeight = 13
  object lbNum: TLabel [0]
    Left = 73
    Top = 151
    Width = 37
    Height = 13
    Caption = 'Номер:'
  end
  object lbDateWhere: TLabel [1]
    Left = 135
    Top = 178
    Width = 69
    Height = 13
    Caption = 'Дата выдачи:'
  end
  object lbProfession: TLabel [2]
    Left = 29
    Top = 13
    Width = 81
    Height = 13
    Caption = 'Специальность:'
  end
  object lbTypeStud: TLabel [3]
    Left = 39
    Top = 40
    Width = 71
    Height = 13
    Caption = 'Вид обучения:'
  end
  object lbEduc: TLabel [4]
    Left = 19
    Top = 67
    Width = 91
    Height = 13
    Caption = 'Вид образования:'
  end
  object lbCraft: TLabel [5]
    Left = 32
    Top = 95
    Width = 78
    Height = 13
    Caption = 'Квалификация:'
  end
  object lbFinishDate: TLabel [6]
    Left = 119
    Top = 206
    Width = 85
    Height = 13
    Caption = 'Дата окончания:'
  end
  object lbSchool: TLabel [7]
    Left = 7
    Top = 123
    Width = 103
    Height = 13
    Caption = 'Учебное заведение:'
  end
  inherited pnBut: TPanel
    Top = 241
    Width = 319
    TabOrder = 14
    inherited Panel2: TPanel
      Left = 134
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 225
    TabOrder = 13
  end
  object edNum: TEdit [10]
    Left = 119
    Top = 147
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 10
    OnChange = edProfessionChange
  end
  object dtpDateWhere: TDateTimePicker [11]
    Left = 214
    Top = 174
    Width = 94
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 11
    OnChange = edProfessionChange
  end
  object edProfession: TEdit [12]
    Left = 119
    Top = 10
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edProfessionChange
  end
  object bibProfession: TBitBtn [13]
    Left = 288
    Top = 10
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibProfessionClick
  end
  object edTypeStud: TEdit [14]
    Left = 119
    Top = 37
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edProfessionChange
  end
  object bibTypeStud: TBitBtn [15]
    Left = 288
    Top = 37
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibTypeStudClick
  end
  object edEduc: TEdit [16]
    Left = 119
    Top = 64
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edProfessionChange
  end
  object bibEduc: TBitBtn [17]
    Left = 288
    Top = 64
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibEducClick
  end
  object edCraft: TEdit [18]
    Left = 119
    Top = 92
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnChange = edProfessionChange
  end
  object bibCraft: TBitBtn [19]
    Left = 288
    Top = 92
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibCraftClick
  end
  object dtpFinishDate: TDateTimePicker [20]
    Left = 214
    Top = 202
    Width = 95
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 12
    OnChange = edProfessionChange
  end
  object edSchool: TEdit [21]
    Left = 119
    Top = 120
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 8
    OnChange = edProfessionChange
  end
  object bibSchool: TBitBtn [22]
    Left = 288
    Top = 120
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 9
    OnClick = bibSchoolClick
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 249
  end
end
