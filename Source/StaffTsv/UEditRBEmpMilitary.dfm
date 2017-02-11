inherited fmEditRBEmpMilitary: TfmEditRBEmpMilitary
  Left = 289
  Top = 124
  Caption = 'fmEditRBEmpMilitary'
  ClientHeight = 335
  ClientWidth = 314
  PixelsPerInch = 96
  TextHeight = 13
  object lbReady: TLabel [0]
    Left = 57
    Top = 124
    Width = 50
    Height = 13
    Caption = 'Годность:'
  end
  object lbCraftNum: TLabel [1]
    Left = 26
    Top = 151
    Width = 81
    Height = 13
    Caption = 'Специальность:'
  end
  object lbDateStart: TLabel [2]
    Left = 94
    Top = 233
    Width = 109
    Height = 13
    Caption = 'Дата начала службы:'
  end
  object lbPlantName: TLabel [3]
    Left = 48
    Top = 13
    Width = 59
    Height = 13
    Caption = 'Военкомат:'
  end
  object lbMilRank: TLabel [4]
    Left = 16
    Top = 40
    Width = 91
    Height = 13
    Caption = 'Воинское звание:'
  end
  object lbRank: TLabel [5]
    Left = 68
    Top = 67
    Width = 39
    Height = 13
    Caption = 'Состав:'
  end
  object lbGroupMil: TLabel [6]
    Left = 69
    Top = 95
    Width = 38
    Height = 13
    Caption = 'Группа:'
  end
  object lbSpecInclude: TLabel [7]
    Left = 52
    Top = 178
    Width = 55
    Height = 13
    Caption = 'Спец. учет:'
  end
  object lbMOB: TLabel [8]
    Left = 11
    Top = 205
    Width = 96
    Height = 13
    Caption = 'МОБ предписание:'
  end
  object lbDateFinish: TLabel [9]
    Left = 99
    Top = 261
    Width = 104
    Height = 13
    Caption = 'Дата конца службы:'
  end
  inherited pnBut: TPanel
    Top = 297
    Width = 314
    TabOrder = 16
    inherited Panel2: TPanel
      Left = 129
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 281
    TabOrder = 15
  end
  object edCraftNum: TEdit [12]
    Left = 114
    Top = 147
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 10
    OnChange = edPlantNameChange
  end
  object dtpDateStart: TDateTimePicker [13]
    Left = 210
    Top = 229
    Width = 94
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    ShowCheckbox = True
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 13
    OnChange = edPlantNameChange
  end
  object edPlantName: TEdit [14]
    Left = 114
    Top = 10
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edPlantNameChange
  end
  object bibPlantName: TBitBtn [15]
    Left = 283
    Top = 10
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPlantNameClick
  end
  object edMilRank: TEdit [16]
    Left = 114
    Top = 37
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edPlantNameChange
  end
  object bibMilrank: TBitBtn [17]
    Left = 283
    Top = 37
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibMilrankClick
  end
  object edRank: TEdit [18]
    Left = 114
    Top = 64
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edPlantNameChange
  end
  object bibRank: TBitBtn [19]
    Left = 283
    Top = 64
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibRankClick
  end
  object edGroupMil: TEdit [20]
    Left = 114
    Top = 92
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 6
    OnChange = edPlantNameChange
  end
  object bibGroupMil: TBitBtn [21]
    Left = 283
    Top = 92
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 7
    OnClick = bibGroupMilClick
  end
  object edSpecInclude: TEdit [22]
    Left = 114
    Top = 174
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 11
    OnChange = edPlantNameChange
  end
  object edMOB: TEdit [23]
    Left = 114
    Top = 201
    Width = 190
    Height = 21
    MaxLength = 30
    TabOrder = 12
    OnChange = edPlantNameChange
  end
  object dtpDateFinish: TDateTimePicker [24]
    Left = 210
    Top = 257
    Width = 95
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    ShowCheckbox = True
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 14
    OnChange = edPlantNameChange
  end
  object edReady: TEdit [25]
    Left = 114
    Top = 120
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 8
    OnChange = edPlantNameChange
  end
  object bibReady: TBitBtn [26]
    Left = 283
    Top = 120
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 9
    OnClick = bibReadyClick
  end
  inherited IBTran: TIBTransaction
    Left = 96
    Top = 297
  end
end
