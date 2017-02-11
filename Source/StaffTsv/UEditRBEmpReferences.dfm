inherited fmEditRBEmpReferences: TfmEditRBEmpReferences
  Left = 333
  Top = 158
  Caption = 'fmEditRBEmpReferences'
  ClientHeight = 131
  ClientWidth = 368
  PixelsPerInch = 96
  TextHeight = 13
  object lbTypeReferences: TLabel [0]
    Left = 10
    Top = 12
    Width = 67
    Height = 13
    Caption = 'Вид справки:'
  end
  object lbDateStart: TLabel [1]
    Left = 10
    Top = 40
    Width = 67
    Height = 13
    Caption = 'Дата начала:'
  end
  object lbDateFinish: TLabel [2]
    Left = 170
    Top = 39
    Width = 85
    Height = 13
    Caption = 'Дата окончания:'
  end
  inherited pnBut: TPanel
    Top = 93
    Width = 368
    TabOrder = 7
    inherited Panel2: TPanel
      Left = 183
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 77
    TabOrder = 6
  end
  object edTypeReferences: TEdit [5]
    Left = 84
    Top = 9
    Width = 257
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edTypeReferencesChange
  end
  object bibTypeReferences: TBitBtn [6]
    Left = 341
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibTypeReferencesClick
  end
  object dtpDateStart: TDateTimePicker [7]
    Left = 84
    Top = 36
    Width = 79
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 2
    OnChange = edTypeReferencesChange
  end
  object dtpDateFinish: TDateTimePicker [8]
    Left = 262
    Top = 36
    Width = 79
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    Checked = False
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 3
    OnChange = edTypeReferencesChange
  end
  object chbOk: TCheckBox [9]
    Left = 84
    Top = 61
    Width = 79
    Height = 17
    Caption = 'Заверено'
    TabOrder = 5
    OnClick = edTypeReferencesChange
  end
  object bibPeriod: TBitBtn [10]
    Left = 341
    Top = 36
    Width = 21
    Height = 21
    Hint = 'Выбрать период'
    Caption = '...'
    TabOrder = 4
    OnClick = bibPeriodClick
  end
  inherited IBTran: TIBTransaction
    Left = 104
    Top = 97
  end
end
