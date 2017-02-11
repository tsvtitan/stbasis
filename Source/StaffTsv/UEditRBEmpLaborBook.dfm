inherited fmEditRBEmpLaborBook: TfmEditRBEmpLaborBook
  Left = 322
  Top = 179
  Caption = 'fmEditRBEmpLaborBook'
  ClientHeight = 298
  ClientWidth = 321
  PixelsPerInch = 96
  TextHeight = 13
  object lbProf: TLabel [0]
    Left = 61
    Top = 12
    Width = 55
    Height = 13
    Caption = 'Професия:'
  end
  object lbDateStart: TLabel [1]
    Left = 49
    Top = 91
    Width = 67
    Height = 13
    Caption = 'Дата начала:'
  end
  object lbDateFinish: TLabel [2]
    Left = 31
    Top = 116
    Width = 85
    Height = 13
    Caption = 'Дата окончания:'
  end
  object lbPlant: TLabel [3]
    Left = 51
    Top = 38
    Width = 65
    Height = 13
    Caption = 'Где работал:'
  end
  object lbMotive: TLabel [4]
    Left = 8
    Top = 64
    Width = 108
    Height = 13
    Caption = 'Причина увольнения:'
  end
  inherited pnBut: TPanel
    Top = 260
    Width = 321
    TabOrder = 11
    inherited Panel2: TPanel
      Left = 136
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 245
    TabOrder = 10
  end
  object edProf: TEdit [7]
    Left = 123
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edProfChange
  end
  object bibProf: TBitBtn [8]
    Left = 292
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibProfClick
  end
  object dtpDateStart: TDateTimePicker [9]
    Left = 123
    Top = 87
    Width = 95
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 6
    OnChange = edProfChange
  end
  object dtpDateFinish: TDateTimePicker [10]
    Left = 123
    Top = 114
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
    TabOrder = 7
    OnChange = edProfChange
  end
  object edPlant: TEdit [11]
    Left = 123
    Top = 35
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edProfChange
  end
  object bibPlant: TBitBtn [12]
    Left = 292
    Top = 35
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibPlantClick
  end
  object edMotive: TEdit [13]
    Left = 123
    Top = 61
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edProfChange
  end
  object bibMotive: TBitBtn [14]
    Left = 292
    Top = 61
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibMotiveClick
  end
  object grb: TGroupBox [15]
    Left = 8
    Top = 156
    Width = 305
    Height = 86
    Caption = 'Примечание'
    Constraints.MinWidth = 180
    TabOrder = 9
    object pngrb: TPanel
      Left = 2
      Top = 15
      Width = 301
      Height = 69
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
      object meHint: TMemo
        Left = 5
        Top = 5
        Width = 291
        Height = 59
        Align = alClient
        TabOrder = 0
        OnChange = edProfChange
      end
    end
  end
  object chbMainProf: TCheckBox [16]
    Left = 122
    Top = 139
    Width = 132
    Height = 17
    Caption = 'Основная профессия'
    TabOrder = 8
    OnClick = edProfChange
  end
  inherited IBTran: TIBTransaction
    Left = 112
    Top = 265
  end
end
