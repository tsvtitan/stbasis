inherited fmEditRBEmpQual: TfmEditRBEmpQual
  Left = 322
  Top = 179
  Caption = 'fmEditRBEmpQual'
  ClientHeight = 169
  ClientWidth = 305
  PixelsPerInch = 96
  TextHeight = 13
  object lbDocum: TLabel [0]
    Left = 25
    Top = 12
    Width = 74
    Height = 13
    Caption = 'На основании:'
  end
  object lbDateStart: TLabel [1]
    Left = 10
    Top = 94
    Width = 89
    Height = 13
    Caption = 'Дата аттестации:'
  end
  object lbTypeResQual: TLabel [2]
    Left = 17
    Top = 66
    Width = 82
    Height = 13
    Caption = 'Тип результата:'
  end
  object lbResDocum: TLabel [3]
    Left = 44
    Top = 39
    Width = 55
    Height = 13
    Caption = 'Результат:'
  end
  inherited pnBut: TPanel
    Top = 131
    Width = 305
    TabOrder = 8
    inherited Panel2: TPanel
      Left = 120
    end
  end
  inherited cbInString: TCheckBox
    Left = 8
    Top = 114
    TabOrder = 7
  end
  object edDocum: TEdit [6]
    Left = 107
    Top = 9
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 0
    OnChange = edDocumChange
  end
  object bibDocum: TBitBtn [7]
    Left = 276
    Top = 9
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 1
    OnClick = bibDocumClick
  end
  object dtpDateStart: TDateTimePicker [8]
    Left = 107
    Top = 90
    Width = 89
    Height = 22
    CalAlignment = dtaLeft
    Date = 37156
    Time = 37156
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 6
    OnChange = edDocumChange
  end
  object edTypeResQual: TEdit [9]
    Left = 107
    Top = 63
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 4
    OnChange = edDocumChange
  end
  object bibTypeResQual: TBitBtn [10]
    Left = 276
    Top = 63
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 5
    OnClick = bibTypeResQualClick
  end
  object edresdocum: TEdit [11]
    Left = 107
    Top = 36
    Width = 169
    Height = 21
    Color = clBtnFace
    MaxLength = 100
    ReadOnly = True
    TabOrder = 2
    OnChange = edDocumChange
  end
  object bibResDocum: TBitBtn [12]
    Left = 276
    Top = 36
    Width = 21
    Height = 21
    Hint = 'Выбрать'
    Caption = '...'
    TabOrder = 3
    OnClick = bibResDocumClick
  end
  inherited IBTran: TIBTransaction
    Left = 248
    Top = 89
  end
end
