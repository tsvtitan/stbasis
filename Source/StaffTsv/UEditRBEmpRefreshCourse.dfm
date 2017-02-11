inherited fmEditRBEmpRefreshCourse: TfmEditRBEmpRefreshCourse
  Left = 322
  Top = 179
  Caption = 'fmEditRBEmpRefreshCourse'
  ClientHeight = 219
  ClientWidth = 298
  PixelsPerInch = 96
  TextHeight = 13
  object lbProf: TLabel [0]
    Left = 37
    Top = 12
    Width = 55
    Height = 13
    Caption = 'Професия:'
  end
  object lbDateStart: TLabel [1]
    Left = 25
    Top = 117
    Width = 67
    Height = 13
    Caption = 'Дата начала:'
  end
  object lbDateFinish: TLabel [2]
    Left = 7
    Top = 142
    Width = 85
    Height = 13
    Caption = 'Дата окончания:'
  end
  object lbPlant: TLabel [3]
    Left = 71
    Top = 38
    Width = 21
    Height = 13
    Caption = 'Где:'
  end
  object lbDocum: TLabel [4]
    Left = 18
    Top = 64
    Width = 74
    Height = 13
    Caption = 'На основании:'
  end
  object lbAbsence: TLabel [5]
    Left = 31
    Top = 90
    Width = 61
    Height = 13
    Caption = 'Вид неявки:'
  end
  inherited pnBut: TPanel
    Top = 181
    Width = 298
    TabOrder = 11
    inherited Panel2: TPanel
      Left = 113
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 164
    TabOrder = 10
  end
  object edProf: TEdit [8]
    Left = 99
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edProfChange
  end
  object bibProf: TBitBtn [9]
    Left = 268
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibProfClick
  end
  object dtpDateStart: TDateTimePicker [10]
    Left = 99
    Top = 113
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
    OnChange = edProfChange
  end
  object dtpDateFinish: TDateTimePicker [11]
    Left = 99
    Top = 140
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
    TabOrder = 9
    OnChange = edProfChange
  end
  object edPlant: TEdit [12]
    Left = 99
    Top = 35
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edProfChange
  end
  object bibPlant: TBitBtn [13]
    Left = 268
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibPlantClick
  end
  object edDocum: TEdit [14]
    Left = 99
    Top = 61
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edProfChange
  end
  object bibDocum: TBitBtn [15]
    Left = 268
    Top = 61
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibDocumClick
  end
  object edAbsence: TEdit [16]
    Left = 99
    Top = 87
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
  end
  object bibAbsence: TBitBtn [17]
    Left = 268
    Top = 87
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibAbsenceClick
  end
  inherited IBTran: TIBTransaction
    Left = 224
  end
end
