inherited fmEditRBEmpBiography: TfmEditRBEmpBiography
  Left = 289
  Top = 125
  Caption = 'fmEditRBEmpBiography'
  ClientHeight = 194
  ClientWidth = 370
  PixelsPerInch = 96
  TextHeight = 13
  object lbDateStart: TLabel [0]
    Left = 9
    Top = 10
    Width = 67
    Height = 13
    Caption = 'Дата начала:'
  end
  object lbDateFinish: TLabel [1]
    Left = 180
    Top = 10
    Width = 85
    Height = 13
    Caption = 'Дата окончания:'
  end
  object lbNote: TLabel [2]
    Left = 8
    Top = 32
    Width = 66
    Height = 13
    Caption = 'Примечание:'
  end
  inherited pnBut: TPanel
    Top = 156
    Width = 370
    TabOrder = 4
    inherited Panel2: TPanel
      Left = 185
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 141
    TabOrder = 3
  end
  object dtpDateStart: TDateTimePicker [5]
    Left = 88
    Top = 6
    Width = 84
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
    OnChange = edProfessionChange
  end
  object dtpDateFinish: TDateTimePicker [6]
    Left = 275
    Top = 6
    Width = 85
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
    OnChange = edProfessionChange
  end
  object meNote: TMemo [7]
    Left = 8
    Top = 51
    Width = 353
    Height = 86
    TabOrder = 2
    OnChange = meNoteChange
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 153
  end
end
