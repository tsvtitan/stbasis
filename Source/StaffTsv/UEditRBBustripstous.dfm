inherited fmEditRBBustripstous: TfmEditRBBustripstous
  Caption = 'fmEditRBBustripstous'
  ClientHeight = 242
  ClientWidth = 297
  PixelsPerInch = 96
  TextHeight = 13
  object lbPlant: TLabel [0]
    Left = 30
    Top = 12
    Width = 39
    Height = 13
    Caption = 'Откуда:'
  end
  object lbSeat: TLabel [1]
    Left = 8
    Top = 39
    Width = 61
    Height = 13
    Caption = 'Должность:'
  end
  object lbDateStart: TLabel [2]
    Left = 107
    Top = 144
    Width = 81
    Height = 13
    Caption = 'Дата прибытия:'
  end
  object lbDateFinish: TLabel [3]
    Left = 111
    Top = 169
    Width = 77
    Height = 13
    Caption = 'Дата выбытия:'
  end
  object lbFName: TLabel [4]
    Left = 17
    Top = 66
    Width = 52
    Height = 13
    Caption = 'Фамилия:'
  end
  object lbName: TLabel [5]
    Left = 44
    Top = 92
    Width = 25
    Height = 13
    Caption = 'Имя:'
  end
  object lbSName: TLabel [6]
    Left = 19
    Top = 118
    Width = 50
    Height = 13
    Caption = 'Отчество:'
  end
  inherited pnBut: TPanel
    Top = 204
    Width = 297
    TabOrder = 10
    inherited Panel2: TPanel
      Left = 112
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 188
    TabOrder = 9
  end
  object edPlant: TEdit [9]
    Left = 78
    Top = 8
    Width = 189
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edPlantChange
  end
  object bibPlant: TBitBtn [10]
    Left = 267
    Top = 8
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibPlantClick
  end
  object edSeat: TEdit [11]
    Left = 78
    Top = 35
    Width = 189
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edPlantChange
  end
  object bibSeat: TBitBtn [12]
    Left = 267
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibSeatClick
  end
  object dtpDateStart: TDateTimePicker [13]
    Left = 198
    Top = 140
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 7
    OnChange = edPlantChange
  end
  object dtpDateFinish: TDateTimePicker [14]
    Left = 198
    Top = 167
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
    TabOrder = 8
    OnChange = edPlantChange
  end
  object edFname: TEdit [15]
    Left = 78
    Top = 62
    Width = 208
    Height = 21
    MaxLength = 100
    TabOrder = 4
    OnChange = edPlantChange
  end
  object edName: TEdit [16]
    Left = 78
    Top = 88
    Width = 208
    Height = 21
    MaxLength = 30
    TabOrder = 5
    OnChange = edPlantChange
  end
  object edSname: TEdit [17]
    Left = 78
    Top = 114
    Width = 208
    Height = 21
    MaxLength = 30
    TabOrder = 6
    OnChange = edPlantChange
  end
  inherited IBTran: TIBTransaction
    Left = 40
    Top = 137
  end
end
